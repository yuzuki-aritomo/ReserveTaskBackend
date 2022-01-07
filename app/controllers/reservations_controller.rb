class ReservationsController < ApplicationController
  before_action :authenticate_user!

  def openings
    params = openings_params
    start_date = string_to_datetime_or_nil(params[:start]) || Time.zone.now.prev_month
    end_date = string_to_datetime_or_nil(params[:end]) || Time.zone.now.next_month
    reservation_Ids = Reservation.where(cancel_flag: false).distinct.pluck(:reception_id)
    receptions = Reception.where(received_at: start_date...end_date).where.not(id: reservation_Ids)
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
    render json: { 'reception_dates': response }
  end

  def index
    params = get_params
    start_date = string_to_datetime_or_nil(params[:start]) || Time.zone.now.prev_month
    end_date = string_to_datetime_or_nil(params[:end]) || Time.zone.now.next_month
    receptions = Reception.includes(reservation: :user)
              .where('receptions.received_at BETWEEN ? AND ?', start_date, end_date)
              .where('reservations.user_id': current_user.id)
              .where('reservations.cancel_flag': false)
    reservation_dates = []
    receptions.map do |reception|
      reservation_dates.push({
        'reservation_id': reception.reservation.first.id,
        'fp_name': reception.user.name,
        'start': reception.received_at.iso8601,
        'end': (reception.received_at + 60 * 30).iso8601,
        'reserved': true
      })
    end
    response = {
      data: reservation_dates
    }
    render json: response
  end

  def create
    params = create_params
    reception = Reception.find(params[:reception_id])
    reservation = reception.reservation.build(user_id: current_user.id)
    response = {}
    if reservation.save
      response = {
        'reservatin_id': reservation.id,
        'fp_name': reception.user.name,
        'reserved': true,
        'start': reception.received_at.iso8601,
        'end': (reception.received_at + 60 * 30).iso8601
      }
    else
      render_400(reservation.errors.full_messages)
      return
    end
    render json: response
  end

  def destroy
    params = destroy_params
    reservation = Reservation.find(params[:id])
    response = {}
    reservation.current_user = current_user
    if reservation.valid? && reservation.update(cancel_flag: true)
      response = {
        'reservatin_id': reservation.id,
        'fp_name': reservation.reception.user.name,
        'customer_name': reservation.user.name,
        'reserved': true,
        'start': reservation.reception.received_at.iso8601,
        'end': (reservation.reception.received_at + 60 * 30).iso8601
      }
    else
      render_400(reservation.errors.full_messages)
      return
    end
    render josn: response
  rescue ActiveRecord::RecordNotFound
    render_400('予約が存在しません')
  rescue StandardError => e
    render_500(e)
  end

  private

    def openings_params
      params.permit(:start, :end)
    end

    def get_params
      params.permit(:start, :end)
    end

    def create_params
      params.permit(:reception_id)
    end

    def destroy_params
      params.permit(:id)
    end

    def string_to_datetime_or_nil(str)
      Time.zone.parse(str)
    rescue StandardError
      nil
    end
end
