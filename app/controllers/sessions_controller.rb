class SessionsController < ApplicationController
  before_action :require_user, only: :destroy

  def new
    redirect_to home_path if logged_in?
  end

  def create
    user = User.find_by(email: params[:email])
    if user and user.authenticate(params[:password])
      if user.active
        session[:user_id] = user.id
        flash[:success] = "You have successfully signed in."
        redirect_to home_path
      else
        flash[:danger] = "Your account has been suspended. Contact customer service for more info."
        redirect_to sign_in_path
      end
    else
      flash[:danger] = "Invalid email or password."
      redirect_to sign_in_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "You have successfully signed out."
    redirect_to root_path
  end
end