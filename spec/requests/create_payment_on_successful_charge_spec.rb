require 'spec_helper'

describe "Create payment on successful charge" do
  let(:event_data) do
    {
      "id" => "evt_15wftSCefoGgth4QYXC63ZF5",
      "created" => 1430255126,
      "livemode" => false,
      "type" => "charge.succeeded",
      "data" => {
        "object" => {
          "id" => "ch_15wftRCefoGgth4QzvjDy1cI",
          "object" => "charge",
          "created" => 1430255125,
          "livemode" => false,
          "paid" => true,
          "status" => "succeeded",
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "source" => {
            "id" => "card_15wftQCefoGgth4QZgpY5uDn",
            "object" => "card",
            "last4" => "4242",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 4,
            "exp_year" => 2018,
            "fingerprint" => "covvpkA6on6GRi6z",
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
            "customer" => "cus_68xpXoPXstyCqd"
          },
          "captured" => true,
          "balance_transaction" => "txn_15wftRCefoGgth4QIjDKAsNK",
          "failure_message" => nil,
          "failure_code" => nil,
          "amount_refunded" => 0,
          "customer" => "cus_68xpXoPXstyCqd",
          "invoice" => "in_15wftRCefoGgth4QSbxYXTVm",
          "description" => nil,
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
            "url" => "/v1/charges/ch_15wftRCefoGgth4QzvjDy1cI/refunds",
            "data" => []
          }
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_68xpWEIg3udQzB",
      "api_version" => "2015-04-07"
    }
  end

  it "creates a payment with the webhook from stripe for charge succeeded", :vcr do
    post '/stripe-events', event_data
    expect(Payment.count).to eq(1)
  end

  it "creates the payment associated with the user", :vcr do
    bob = Fabricate(:user, customer_token: "cus_68xpXoPXstyCqd")
    post '/stripe-events', event_data
    expect(Payment.first.user).to eq(bob)
  end

  it "creates the payment with the amount", :vcr do
    bob = Fabricate(:user, customer_token: "cus_68xpXoPXstyCqd")
    post '/stripe-events', event_data
    expect(Payment.first.amount).to eq(999)
  end

  it "creates the payment with reference_id", :vcr do
    bob = Fabricate(:user, customer_token: "cus_68xpXoPXstyCqd")
    post '/stripe-events', event_data
    expect(Payment.first.reference_id).to eq("ch_15wftRCefoGgth4QzvjDy1cI")
  end
end