class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  skip_before_action :verify_authenticity_token

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:role, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:role, :email, :password, :password_confirmation, :current_password) }
    devise_parameter_sanitizer.permit(:accept_invitation) { |u| u.permit(:email, :password, :password_confirmation, :invitation_token) }
    devise_parameter_sanitizer.permit(:invite) { |u| u.permit(:role, :email, :full_name) }
  end
end
