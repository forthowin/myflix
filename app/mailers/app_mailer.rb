class AppMailer < ActionMailer::Base
  def send_welcome_mail(user)
    @user = user
    mail to: user.email, from: "info@myflix.com", subject: "Welcome to myflix!"
  end

  def send_forgot_password(user)
    @user = user
    mail to: user.email, from: "info@myflix.com", subject: "Reset password confirmation"
  end

  def send_invitation(invitation)
    @invitation = invitation
    mail to: invitation.recipient_email, from: invitation.inviter.email, subject: "Invitation to myflix!"
  end
end