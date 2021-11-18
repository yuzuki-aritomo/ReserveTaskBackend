class ReceptionsController < ApplicationController
  # user 認証入れる
  # before_action :authenticate_user!
  def create
    request_body = JSON.parse(request.body.read, {:symbolize_names => true})
    register_dates = request_body[:register_date]
    reception_dates = []
    register_dates.each do |register_date|
      @reception = Reception.new(
        user_id: 1, # current_user.id
        date: register_date,
      )
      if @reception.save
        reception_dates.push({
          "reception_id": @reception.id,
          "user_name": "taro", # current_user.name
          "start": @reception.date.iso8601,
          "end": (@reception.date + 60*30).iso8601,
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
