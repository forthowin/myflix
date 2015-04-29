require 'spec_helper'

feature "Deactivate user on failed charge" do
  let(:event_data) do
    {
      "id" => "evt_15wkhcCefoGgth4QyCrpH2FP",
      "created" => 1430273612,
      "livemode" => false,
      "type" => "charge.failed",
      "data" => {
        "object" => {
          "id" => "ch_15wkhcCefoGgth4Q9pXdSq2d",
          "object" => "charge",
          "created" => 1430273612,
          "livemode" => false,
          "paid" => false,
          "status" => "failed",
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "source" => {
            "id" => "card_15wkZDCefoGgth4Q5OUhPSf3",
            "object" => "card",
            "last4" => "0341",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 4,
            "exp_year" => 2018,
            "fingerprint" => "B2Nu3hCQ2DXXCk82",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil,
            "dynamic_last4" => nil,
            "metadata" => {},
            "customer" => "cus_68yk5EUZKCQoou"
          },
          "captured" => false,
          "balance_transaction" => nil,
          "failure_message" => "Your card was declined.",
          "failure_code" => "card_declined",
          "amount_refunded" => 0,
          "customer" => "cus_68yk5EUZKCQoou",
          "invoice" => nil,
          "description" => "failed charge",
          "dispute" => nil,
          "metadata" => {},
          "statement_descriptor" => nil,
          "fraud_details" => {},
          "receipt_email" => nil,
          "receipt_number" => nil,
          "shipping" => nil,
          "application_fee" => nil,
          "refunds" => {
            "object" => "list",
            "total_count" => 0,
            "has_more" => false,
            "url" => "/v1/charges/ch_15wkhcCefoGgth4Q9pXdSq2d/refunds",
            "data" => []
          }
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_692nIetUA4j4hZ",
      "api_version" => "2015-04-07"
    }
  end

  it "deactivates a user with the webhook data from stripe for failed charge", :vcr do
    bob = Fabricate(:user, customer_token: "cus_68yk5EUZKCQoou")
    post '/stripe-events', event_data
    expect(bob.reload).not_to be_active
  end
end