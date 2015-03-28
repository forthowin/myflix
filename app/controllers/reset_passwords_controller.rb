class ResetPasswordsController < ApplicationController
  def show
    user = User.where(token: params[:id]).first
    if user
      @token = user.token
    else
      redirect_to invalid_token_path
    end
  end

  def create
    user = User.where(token: params[:token]).first
    if user
      if user.update(token: nil, password: params[:password])
        flash[:success] = "Your password has been updated."
        redirect_to sign_in_path
      else
        flash[:danger] = "Password cannot be blank."
        redirect_to reset_password_path(params[:token])
      end
    else
      redirect_to invalid_token_path
    end
  end

  def invalid_token
  end
end