class UserSignup
  attr_reader :error_message, :user_id

  def initialize(user)
    @user = user
  end

  def sign_up(stripe_token, invitation_token)
    if @user.valid?
      customer = StripeWrapper::Customer.create(
        :source => stripe_token,
        :user => @user
      )
      if customer.successful?
        @user.customer_token = customer.customer_token
        @user.save
        handle_token(invitation_token)
        AppMailer.delay.send_welcome_mail(@user)
        @user_id = @user.id
        @status = :success
        self
      else
        @error_message = customer.error_message
        @status = :failed
        self
      end
    else
      @error_message = "There were some errors."
      @status = :failed
      self
    end
  end

  def successful?
    @status == :success
  end

  private 

  def handle_token(invitation_token)
    if invitation_token.present?
      invitation = Invitation.where("token = ?", invitation_token).first
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update(token: nil)
    end
  end
end