Rails.configuration.stripe = {
  :publishable_key => ENV['STRIP_PUBLISHABLE_KEY'],
  :secret_key      => ENV['STRIP_SECRET_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]