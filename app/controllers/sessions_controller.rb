class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email params[:email]
    if user && user.authenticate(params[:password])
      if params[:remember_me]
        cookies.signed.permanent[:auth_token] = user.auth_token
      else
        cookies.signed[:auth_token] = user.auth_token
      end
      redirect_to root_url
    else
      flash.now.alert = "Invalid email or password"
      render :new
    end
  end

  def destroy
    cookies.delete :auth_token
    redirect_to root_url, :notice => "Logged out successfully."
  end
end
