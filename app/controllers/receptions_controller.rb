# frozen_string_literal: true

class ReceptionsController < ApplicationController
  before_action :authenticate_user!

  def index
    params = get_params
    start_date = string_to_datetime_or_nil(params[:start]) || Time.zone.now.prev_month
    end_date = string_to_datetime_or_nil(params[:end]) || Time.zone.now.next_month
    receptions = Reception.includes(reservation: :user)
            .where('receptions.user_id': current_user.id)
            .where("receptions.received_at BETWEEN ? AND ?", start_date, end_date)
            .where("reservations.cancel_flag": [nil, false])
    reception_dates = []
    receptions.map do |reception|
      reception_dates.push({
        "reception_id": reception.id,
        "customer_name": reception.reservation.first ? reception.reservation.first.user.name : '',
        "start": reception.received_at.iso8601,
        "end": (reception.received_at + 60 * 30).iso8601,
        "reserved": reception.reservation.first ? true : false
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
          "customer_name": current_user.name,
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

  private

    def get_params
      params.permit(:start, :end)
    end

    def create_params
      params.require(:register_date)
    end

    def string_to_datetime_or_nil(str)
      Time.zone.parse(str)
    rescue StandardError
      nil
    end
end
