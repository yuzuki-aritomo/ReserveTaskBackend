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
end
