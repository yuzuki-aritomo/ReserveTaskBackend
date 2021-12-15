class ReceptionsController < ApplicationController
  before_action :authenticate_user!

  def index
    reception_form = ReceptionsListsForm.new(
      current_user,
      params.permit(:start, :end)
    )
    response = reception_form.execute
    render json: response
  end

  def create
    register_dates = create_params
    success_dates = []
    error_dates = []
    register_dates.each do |register_date|
      reception = current_user.reception.build(received_at: register_date)
      if reception.save
        success_dates.push({
          "reception_id": reception.id,
          "user_name": current_user.name,
          "start": reception.received_at.iso8601,
          "end": (reception.received_at + 60 * 30).iso8601,
          "reserved": false
        })
      else
        error_dates.push({
          "date": reception.received_at,
          "error_messages": reception.errors.full_messages
        })
      end
    end
    response = {
      "data": success_dates,
      "error": error_dates
    }
    render json: response
  end

  private

    def create_params
      params.require(:register_date)
    end
end
