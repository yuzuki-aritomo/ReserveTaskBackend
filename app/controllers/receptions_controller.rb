class ReceptionsController < ApplicationController
  def create
    request_body = JSON.parse(request.body.read, {:symbolize_names => true})
    time_list = request_body[:register_date]
    @reception = Reception.new(
      user_id: 1, date: '2020-09-30T02:30:12+09:00',
    )
    if @reception.save

    else
      
    end

    response = {
      "data": [
        {
          "reception_id": 2,
          "user_name": "taro",
          "start": "2020-09-30T02:00:12+09:00",
          "end": "2020-09-30T02:30:12+09:00",
          "reserved": true,
          "canceled": false
        },
      ]
    }
    render json: @reception
  end
end
