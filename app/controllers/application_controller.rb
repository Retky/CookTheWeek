class ApplicationController < ActionController::API
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def current_user
    if request.headers['Authorization'].nil?
      @current_user = nil
    else
      jwt_payload = JWT.decode(request.headers['Authorization'].split.last,
                               Rails.application.credentials.devise_jwt_secret_key!).first
      @current_user = User.find(jwt_payload['sub'])
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[username])
  end
end
