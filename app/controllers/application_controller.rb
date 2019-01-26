class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  def after_sign_in_path_for(resource)
		if current_user.archived
      head(:forbidden)
    end
  end
  
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name,:last_name,:avatar,:date_of_birth,:degree,:phone])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name,:last_name,:avatar,:date_of_birth,:degree,:phone])
  end
  
end
