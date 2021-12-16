class ReceptionsController < ApplicationController
  before_action :authenticate_user!

  def index
    params = get_params
    start_date = convert_to_date(params[:start]) || Time.zone.now.prev_month
    end_date = convert_to_date(params[:end]) || Time.zone.now.next_month
    receptions = current_user.reception.where(received_at: start_date...end_date)
    reception_dates = []
    receptions.map do |reception|
      reservation = reception.reservation.find_by(cancel_flag: false)
      reserved = reservation ? true : false
      user_name = reservation ? reservation.user.name : ''
      reception_dates.push({
        "reception_id": reception.id,
        "user_name": user_name,
        "start": reception.received_at.iso8601,
        "end": (reception.received_at + 60 * 30).iso8601,
        "reserved": reserved
      })
    end
    response = {
      data: reception_dates
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
      "data": success_dates,
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
      render_error('エラーが発生しました。')
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

    def convert_to_date(date)
      Time.zone.parse(date)
    rescue StandardError
      nil
    end

    def skip_reserved
      if @reception.is_reserved
        render_error('予約が完了した予約可能時間は削除できません')
        true
      end
    end

    def render_error(error_message)
      render status: :bad_request, json: {
        status: 400,
        message: error_message
      }
    end
end
