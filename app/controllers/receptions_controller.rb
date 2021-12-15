class ReceptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    reception_form = ReceptionsRegistrationForm.new(
      user: current_user,
      register_dates: params.require(:register_date)
    )
    response = reception_form.execute
    render json: response
  end
end
