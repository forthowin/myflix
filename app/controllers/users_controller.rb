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
    if @user.save
      handle_token
      session[:user_id] = @user.id
      AppMailer.delay.send_welcome_mail(@user)
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

  def handle_token
    if params[:invitation_token].present?
      invitation = Invitation.where("token = ?", params[:invitation_token]).first
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update(token: nil)
    end
  end
end