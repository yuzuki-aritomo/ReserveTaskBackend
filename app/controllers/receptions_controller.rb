# frozen_string_literal: true

class ReceptionsController < ApplicationController
  before_action :authenticate_user!

  def index
    params = get_params
    start_date = string_to_datetime_or_nil(params[:start]) || Time.zone.now.prev_month
    end_date = string_to_datetime_or_nil(params[:end]) || Time.zone.now.next_month
    relation = current_user
               .reception
               .left_joins(:reservation)
               .left_joins(reservation: :user)
               .select('receptions.*, reservations.user_id, users.name')
               .where(receptions: { received_at: start_date...end_date })
    receptions = relation.where(reservations: { cancel_flag: nil }).or(relation.where(reservations: { cancel_flag: false }))
    reception_dates = []
    receptions.map do |reception|
      reception_dates.push({
        "reception_id": reception.id,
        "user_name": reception.user_id ? reception.name : '',
        "start": reception.received_at.iso8601,
        "end": (reception.received_at + 60 * 30).iso8601,
        "reserved": reception.user_id ? true : false
      })
    end
    response = {
      "reception_dates": reception_dates
    }
    render json: response
  end

  def create
    register_dates = create_params
    success_dates = []
    error_dates = []
    register_dates.each do |register_date|
      reception = current_user.reception.build(received_at: register_date)
      if reception.save
        success_dates.push({
          "reception_id": reception.id,
          "user_name": current_user.name,
          "start": reception.received_at.iso8601,
          "end": (reception.received_at + 60 * 30).iso8601,
          "reserved": false
        })
      else
        error_dates.push({
          "date": reception.received_at,
          "error_messages": reception.errors.full_messages
        })
      end
    end
    response = {
      "register_dates": success_dates,
      "error": error_dates
    }
    render json: response
  end

  def destroy
    reception_id = destroy_params
    @reception = current_user.reception.find(reception_id)
    skip_reserved && return
    response = {}
    if @reception.destroy
      response['reception_id'] = @reception.id
      response['user_name'] = ''
      response['start'] = @reception.received_at.iso8601
      response['end'] = (@reception.received_at + 60 * 30).iso8601
      response['reserved'] = false
    else
      render_500('エラーが発生しました。')
      return
    end
    render json: response
  end

  private

    def get_params
      params.permit(:start, :end)
    end

    def create_params
      params.require(:register_date)
    end

    def destroy_params
      params.require(:id)
    end

    def string_to_datetime_or_nil(datetime)
      Time.zone.parse(datetime)
    rescue StandardError
      nil
    end

    def skip_reserved
      if @reception.reserved?
        render_400('予約が完了した予約可能時間は削除できません')
        true
      end
    end
end
