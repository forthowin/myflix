class ForgotPasswordsController < ApplicationController
  def new
  end

  def confirm
  end

  def create
    user = User.find_by email: params[:email]
    if user
      AppMailer.send_forgot_password(user).deliver
      redirect_to forgot_password_confirmation_path
    else
      flash[:danger] = params[:email].blank? ? "Email cannot be blank." : "Cannot find user with that email."
      redirect_to forgot_password_path
    end
  end
end