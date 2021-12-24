# frozen_string_literal: true

class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  private
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role])
    end

    def render_400(error_message)
      render status: :bad_request, json: {
        message: error_message
      }
    end

    def render_500(error_message)
      render status: :internal_server_error, json: {
        message: error_message
      }
    end
end