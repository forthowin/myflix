require 'spec_helper'

describe ForgotPasswordsController do
  describe "POST create" do
    context "with blank input" do
      before { post :create, email: "" }

      it "redirects to the forgot password page" do
        expect(response).to redirect_to forgot_password_path
      end

      it "sets the flash danger message" do
        expect(flash[:danger]).to eq("Email cannot be blank.")
      end
    end

    context "with valid email" do
      let(:bob) { Fabricate(:user) }

      before { post :create, email: bob.email }

      it "sends an email to the user" do
        expect(ActionMailer::Base.deliveries.last.to).to eq([bob.email])
      end

      it "generates a random token for the user" do
        expect(bob.reload.token).to be_present
      end

      it "redirects to forgot password confirmation page" do
        expect(response).to redirect_to forgot_password_confirmation_path
      end
    end

    context "with invalid email" do
      before { post :create, email: "invalid@email.com" }

      it "redirects to the forgot password page" do
        expect(response).to redirect_to forgot_password_path
      end

      it "sets the flash danger message" do
        expect(flash[:danger]).to eq("Cannot find user with that email.")
      end
    end
  end
end