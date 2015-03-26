class AppMailer < ActionMailer::Base
  def send_welcome_mail(user)
    @user = user
    mail to: user.email, from: "info@myflix.com", subject: "Welcome to myflix!"
  end
end