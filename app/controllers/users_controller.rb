class UsersController < ApplicationController
  before_action :require_user, only: :show

  def new
    redirect_to home_path if logged_in?
    @user = User.new
  end

  def new_with_invitation_token
    invitation = Invitation.where("token = ?", params[:token]).first
    if invitation
      @user = User.new(email: invitation.recipient_email)
      @invitation_token = invitation.token
      render :new
    else
      redirect_to invalid_token_path
    end
  end

  def create
    @user = User.new(user_param)
    result = UserSignup.new(@user).sign_up(params[:stripeToken], params[:invitation_token])
    if result.successful?
      session[:user_id] = result.user_id
      flash[:success] = "Thank you for registering with MyFlix!"
      redirect_to home_path
    else
      flash[:danger] = result.error_message
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