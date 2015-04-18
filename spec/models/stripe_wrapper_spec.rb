require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe ".create" do
      it "charges successfully", :vcr do
        Stripe.api_key = ENV['STRIPE_SECRET_KEY']

        token = Stripe::Token.create(
          :card => {
            :number => "4242424242424242",
            :exp_month => 4,
            :exp_year => 2018,
            :cvc => "314"
          }
        ).id

        response = StripeWrapper::Charge.create(
          :amount => 999,
          :source => token,
          :description => "charge successful"
        )

        expect(response.currency).to eq("usd")
        expect(response.amount).to eq(999)
      end
    end
  end
end