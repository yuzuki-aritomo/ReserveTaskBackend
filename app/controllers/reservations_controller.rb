class ReservationsController < ApplicationController
  before_action :authenticate_user!

  def openings
    params = get_params
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

  private

    def get_params
      params.permit(:start, :end)
    end

    def convert_to_date(date)
      Time.zone.parse(date)
    rescue StandardError
      nil
    end
end
