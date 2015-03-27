class UsersController < ApplicationController
  before_action :require_user, only: :show

  def new
    redirect_to home_path if logged_in?
    @user = User.new
  end

  def create
    @user = User.new(user_param)
    if @user.save
      session[:user_id] = @user.id
      AppMailer.send_welcome_mail(@user).deliver
      redirect_to home_path
    else
      render :new
    end
  end

  def show
    @user = User.find params[:id]
  end

  private

  def user_param
    params.require(:user).permit(:email, :password, :full_name)
  end
end