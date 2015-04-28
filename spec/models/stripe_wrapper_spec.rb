require 'spec_helper'

describe StripeWrapper do
  let(:valid_token) do
    Stripe::Token.create(
      :card => {
        :number => "4242424242424242",
        :exp_month => 4,
        :exp_year => 2018,
        :cvc => "314"
      }
    ).id
  end

  let(:invalid_token) do
    token = Stripe::Token.create(
      :card => {
        :number => "4000000000000002",
        :exp_month => 4,
        :exp_year => 2018,
        :cvc => "314"
      }
    ).id
  end

  describe StripeWrapper::Charge do
    describe ".create" do
      it "makes a successful charge", :vcr do
        response = StripeWrapper::Charge.create(
          :amount => 999,
          :source => valid_token,
          :description => "a valid charge"
        )

        expect(response).to be_successful
      end

      it "makes a card declined charge", :vcr do
        response = StripeWrapper::Charge.create(
          :amount => 999,
          :source => invalid_token,
          :description => "an invalid charge"
        )

        expect(response).not_to be_successful
      end

      it "returns an error message for declined charges", :vcr do
        response = StripeWrapper::Charge.create(
          :amount => 999,
          :source => invalid_token,
          :description => "an invalid charge"
        )

        expect(response.error_message).to eq('Your card was declined.')
      end
    end
  end

  describe StripeWrapper::Customer do
    describe ".create" do
      it "creates a customer with a valid card", :vcr do
        bob = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          :source => valid_token,
          :user => bob
        )
        expect(response).to be_successful
      end

      it "does not create a customer with an invalid card", :vcr do
        bob = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          :source => invalid_token,
          :user => bob
        )
        expect(response).not_to be_successful
      end

      it "returns an error message for declined card", :vcr do
        bob = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          :source => invalid_token,
          :user => bob
        )
        expect(response.error_message).to eq("Your card was declined.")
      end

      it "returns a customer token for valid card", :vcr do
        bob = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          :source => valid_token,
          :user => bob
        )
        expect(response.customer_token).to be_present
      end
    end
  end
end