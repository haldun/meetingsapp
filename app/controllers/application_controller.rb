class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  layout :application_layout

  def current_user
    @current_user ||= User.find_by_auth_token(cookies.signed[:auth_token]) if cookies[:auth_token]
  end

  def authenticate_user!
    redirect_to login_url unless current_user
  end

  def application_layout
    current_user ? 'application' : 'site'
  end
end
