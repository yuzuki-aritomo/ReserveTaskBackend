class ReceptionsController < ApplicationController
  before_action :authenticate_user!

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
    @receptions = current_user.reception.where(date: start_date ... end_date)
    reception_dates = []
    @receptions.map do | reception |
      @reservation = reception.reservation.find_by(cancel_flag: false)
      reserved = @reservation ? true : false
      user_name = @reservation ? @reservation.get_user_name() : ""
      reception_dates.push({
        "reception_id": reception.id,
        "user_name": user_name,
        "start": reception.date.iso8601,
        "end": (reception.date + 60*30).iso8601,
        "reserved": reserved,
      })
    end
    response = {
      data: reception_dates
    }
    render json: response
  end

  def create
    reception_form = ReceptionsRegistrationForm.new(
      current_user,
      params.require(:register_date)
    )
    response = reception_form.execute
    render json: response
  end
end
