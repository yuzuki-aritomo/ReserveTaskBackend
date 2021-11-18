class ReceptionsController < ApplicationController
  def create
    request_body = JSON.parse(request.body.read, {:symbolize_names => true})
    register_dates = request_body[:register_date]
    reception_dates = []
    register_dates.each do |register_date|
      @reception = Reception.new(
        user_id: 1,
        date: register_date,
      )
      if @reception.save
        reception_dates.push({
          "reception_id": @reception.id,
          "user_name": "taro",
          "start": @reception.date,
          "end": @reception.date + Rational(1, 24 * 60) ,
          "reserved": false,
          "canceled": false
        })
      end
    end

    response = {
      "data": reception_dates
    }
    render json: response
  end
end
