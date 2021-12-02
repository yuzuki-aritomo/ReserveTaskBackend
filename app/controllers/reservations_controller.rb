class ReservationsController < ApplicationController
  before_action :authenticate_user!

  def openings
    def convert_to_date(date)
      begin
        return Time.parse(date)
      rescue
        return nil
      end
    end
    start_date = convert_to_date(params[:start]) || Time.now.prev_month
    end_date = convert_to_date(params[:end]) || Time.now.next_month
    @receptions = Reception.where(date: start_date ... end_date)
    @receptions = @receptions.filter{ |reception| !reception.is_reserved }
    render json: @receptions
  end

  def index
    def convert_to_date(date)
      begin
        return Time.parse(date)
      rescue
        return nil
      end
    end
    start_date = convert_to_date(params[:start]) || Time.now.prev_month
    end_date = convert_to_date(params[:end]) || Time.now.next_month
    @reservations = current_user.reservation.joins(:reception)
    .select('reservations.*, receptions.date')
    .where(receptions: {date: start_date ... end_date})
    reservation_dates = []
    @reservations.map do | reservation|
      reservation_dates.push({
        'reservation_id': reservation.id,
        'start': reservation.date.iso8601,
        'end': (reservation.date+60*30).iso8601,
        'canceled': reservation.cancel_flag
      })
    end
    response = {
      data: reservation_dates
    }
    render json: response
  end

end
