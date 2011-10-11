class AuthenticationsController < ApplicationController
  respond_to :html, :json

  expose(:authentications) { current_user.authentications }
  expose(:authentication)

  def index
    respond_with authentications
  end

  def create
    omniauth = request.env['omniauth.auth']
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])

    if authentication
      flash.notice = "Signed in successfully."
      cookies.signed[:auth_token] = authentication.user.auth_token
      redirect_to root_url
    elsif current_user
      current_user.authentications.create! provider: omniauth['provider'], uid: omniauth['uid']
      flash.notice = "Authentication successful."
      redirect_to authentications_url
    else
      user = User.new
      user.apply_omniauth(omniauth)
      if user.save
        flash.notice = "Signed in successfully"
        cookies.signed[:auth_token] = user.auth_token
        redirect_to root_url
      else
        session[:omniauth] = omniauth.except('extra')
        redirect_to signup_url
      end
    end
  end

  def destroy
    authentication.destroy
    respond_with authentication
  end
end
