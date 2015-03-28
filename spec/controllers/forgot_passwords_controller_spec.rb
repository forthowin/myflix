require 'spec_helper'

describe ForgotPasswordsController do
  describe "POST create" do
    context "with blank input" do
      it "redirects to the forgot password page" do
        post :create, email: ""
        expect(response).to redirect_to forgot_password_path
      end

      it "sets the flash danger message" do
        post :create, email: ""
        expect(flash[:danger]).to eq("Email cannot be blank.")
      end
    end

    context "with valid email" do
      it "sends an email to the user" do
        bob = Fabricate(:user)
        post :create, email: bob.email
        expect(ActionMailer::Base.deliveries.last.to).to eq([bob.email])
      end

      it "generates a random token for the user" do
        bob = Fabricate(:user)
        post :create, email: bob.email
        expect(bob.reload.token).to be_present
      end

      it "redirects to forgot password confirmation page" do
        bob = Fabricate(:user)
        post :create, email: bob.email
        expect(response).to redirect_to forgot_password_confirmation_path
      end
    end

    context "with invalid email" do
      it "redirects to the forgot password page" do
        post :create, email: "invalid@email.com"
        expect(response).to redirect_to forgot_password_path
      end

      it "sets the flash danger message" do
        post :create, email: "invalid@email.com"
        expect(flash[:danger]).to eq("Cannot find user with that email.")
      end
    end
  end
end