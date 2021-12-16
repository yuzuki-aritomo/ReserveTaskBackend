class ReservationsController < ApplicationController
  before_action :authenticate_user!

  def openings
    params = openings_params
    start_date = convert_to_date(params[:start]) || Time.zone.now.prev_month
    end_date = convert_to_date(params[:end]) || Time.zone.now.next_month
    receptions = Reception.where(received_at: start_date...end_date)
    receptions = receptions.filter { |reception| !reception.reserved? }
    response = []
    receptions.map do |reception|
      response.push({
        "reception_id": reception.id,
        "fp_name": reception.user.name,
        "start": reception.received_at.iso8601,
        "end": (reception.received_at + 60 * 30).iso8601,
        "reserved": false
      })
    end
    render json: response
  end

  def index
    params = get_params
    start_date = convert_to_date(params[:start]) || Time.zone.now.prev_month
    end_date = convert_to_date(params[:end]) || Time.zone.now.next_month
    reservations = current_user.reservation.joins(:reception)
                                .select('reservations.*, receptions.received_at')
                                .where(receptions: { received_at: start_date...end_date })
    reservation_dates = []
    reservations.map do |reservation|
      reservation_dates.push({
        'reservation_id': reservation.id,
        'start': reservation.received_at.iso8601,
        'end': (reservation.received_at + 60 * 30).iso8601,
        'canceled': reservation.cancel_flag
      })
    end
    response = {
      data: reservation_dates
    }
    render json: response
  end

  private

    def openings_params
      params.permit(:start, :end)
    end

    def get_params
      params.permit(:start, :end)
    end

    def convert_to_date(date)
      Time.zone.parse(date)
    rescue StandardError
      nil
    end
end
