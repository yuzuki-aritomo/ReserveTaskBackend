class ReceptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    register_dates = params.require(:register_date)
    reception_dates = []
    error_dates = []
    register_dates.each do |register_date|
      @reception = current_user.reception.build(date: register_date)
      if @reception.save
        reception_dates.push({
          "reception_id": @reception.id,
          "user_name": current_user.name,
          "start": @reception.date.iso8601,
          "end": (@reception.date + 60 * 30).iso8601,
          "reserved": false
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
      "error": error_dates
    }
    render json: response
  end
end
