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
    @receptions = Reception.where(user_id: current_user.id).where(date: start_date ... end_date)
    reception_dates = []
    @receptions.map do | reception |
      @reservation = Reservation.find_by(reception_id: reception.id, cancel_flag: false)
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
      date: reception_dates
    }
    render json: response
  end

  def create
    request_body = JSON.parse(request.body.read, {:symbolize_names => true})
    register_dates = request_body[:register_date]
    reception_dates = []
    error_dates = []
    register_dates.each do |register_date|
      @reception = Reception.new(
        user_id: current_user.id,
        date: register_date,
      )
      if @reception.save
        reception_dates.push({
          "reception_id": @reception.id,
          "user_name": current_user.name,
          "start": @reception.date.iso8601,
          "end": (@reception.date + 60*30).iso8601,
          "reserved": false,
          "canceled": false
        })
      else
        error_dates.push({
          "date": @reception.date,
          "error_messages": @reception.errors.full_messages
        })
      end
    end
    response = {
      "data": reception_dates,
      "error": error_dates,
    }
    render json: response
  end
end
