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
    reception_form = ReceptionsRegistrationForm.new(
      current_user,
      params.require(:register_date)
    )
    response = reception_form.execute
    render json: response
  end
end
