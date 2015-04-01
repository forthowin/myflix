class InvitationsController < ApplicationController
  before_action :require_user

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_param)
    @invitation.inviter = current_user
    if @invitation.save
      flash[:success] = "Email was sent."
      redirect_to invite_path
    else
      render :new
    end
  end

  private

  def invitation_param
    params.require(:invitation).permit(:recipient_name, :recipient_email, :message)
  end
end