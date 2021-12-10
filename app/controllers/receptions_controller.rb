class ReceptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    reception_form = ReceptionsRegistrationForm.new(
      current_user,
      params.require(:register_date)
    )
    response = reception_form.execute
    render json: response
  end
end
