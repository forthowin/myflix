require 'spec_helper'

describe UserSignup do
  describe "#sign_up" do
    context "with valid personal and card info" do
      let(:customer) { double(:customer, successful?: true, customer_token: "asdfg") }
      before { StripeWrapper::Customer.should_receive(:create).and_return(customer) }
      after { ActionMailer::Base.deliveries.clear }

      it "creates the user" do
        UserSignup.new(Fabricate.build(:user)).sign_up("some_stripe_token", nil)
        expect(User.count).to eq(1)
      end

      it "stores the customer token from stripe" do
        UserSignup.new(Fabricate.build(:user)).sign_up("some_stripe_token", nil)
        expect(User.first.customer_token).to eq("asdfg")
      end

      it "makes the user follow the inviter" do
        bob = Fabricate(:user)
        invitation = Fabricate(:invitation, recipient_email: 'bill@example.com', recipient_name: 'Bill Boe', inviter: bob)
        UserSignup.new(Fabricate.build(:user, email: 'bill@example.com', full_name: 'Bill Boe')).sign_up("some_stripe_token", invitation.token)
        bill = User.where(email: 'bill@example.com').first
        expect(bill.follows?(bob)).to be_truthy
      end

      it "makes the inviter follow the user" do
        bob = Fabricate(:user)
        invitation = Fabricate(:invitation, recipient_email: 'bill@example.com', recipient_name: 'Bill Boe', inviter: bob)
        UserSignup.new(Fabricate.build(:user, email: 'bill@example.com', full_name: 'Bill Boe')).sign_up("some_stripe_token", invitation.token)
        bill = User.where(email: 'bill@example.com').first
        expect(bob.follows?(bill)).to be_truthy
      end

      it "expires the invitation upon acceptance" do
        bob = Fabricate(:user)
        invitation = Fabricate(:invitation, recipient_email: 'bill@example.com', recipient_name: 'Bill Boe', inviter: bob)
        UserSignup.new(Fabricate.build(:user, email: 'bill@example.com', full_name: 'Bill Boe')).sign_up("some_stripe_token", invitation.token)
        expect(invitation.reload.token).to be_nil
      end

      it "sends an email to the user with valid inputs" do
        UserSignup.new(Fabricate.build(:user, email: 'bob@myflix.com', full_name: 'bob doe')).sign_up("some_stripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.to).to eq(['bob@myflix.com'])
      end

      it "sends an email containing the user name with valid inputs" do
        UserSignup.new(Fabricate.build(:user, email: 'bob@myflix.com', full_name: 'bob doe')).sign_up("some_stripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.body).to include('bob doe')
      end
    end

    context "with valid personal info and declined card" do
      it "does not create a new user record" do
        customer = double(:customer, successful?: false, error_message: "Your card was declined.")
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
        UserSignup.new(Fabricate.build(:user)).sign_up("12345", nil)
        expect(User.count).to eq(0)
      end
    end

    context "with invalid personal info" do
      it "does not create the user" do
        UserSignup.new(Fabricate.build(:user, email: nil)).sign_up("12345", nil)
        expect(User.count).to eq(0)
      end

      it "does not charge the card" do
        StripeWrapper::Customer.should_not_receive(:customer)
        UserSignup.new(Fabricate.build(:user, email: nil)).sign_up("12345", nil)
      end

      it "does not send an email with invalid inputs" do
        UserSignup.new(Fabricate.build(:user, email: nil)).sign_up("12345", nil)
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end