class UsersController < ApplicationController

  def new
    redirect_to home_path if logged_in?
    @user = User.new
  end

  def create
    @user = User.new(user_param)

    if @user.save
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def user_param
    params.require(:user).permit(:email, :password, :full_name)
  end
end