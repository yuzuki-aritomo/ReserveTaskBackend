class ReservationsController < ApplicationController
  before_action :authenticate_user!

  def openings
    start_date = convert_to_date(params[:start]) || Time.zone.now.prev_month
    end_date = convert_to_date(params[:end]) || Time.zone.now.next_month
    @receptions = Reception.where(date: start_date...end_date)
    @receptions = @receptions.filter { |reception| !reception.is_reserved }
    render json: @receptions
  end

  private

    def convert_to_date(date)
      Time.zone.parse(date)
    rescue StandardError
      nil
    end
end
