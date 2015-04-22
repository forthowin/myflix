require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "assigns @user as new User" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end

    it "renders the new template" do
      get :new
      expect(response).to render_template :new
    end

    it "redirects to home_path if logged in" do
      set_current_user
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe "GET new_with_invitation_token" do
    it "assigns @user with recipient's email" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end

    it "assigns @invitation_token" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end

    it "renders the new template" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template :new
    end

    it "redirects to the invalid token page for invalid token" do
      get :new_with_invitation_token, token: 'asdf'
      expect(response).to redirect_to invalid_token_path
    end
  end

  describe "POST create" do
    context "with valid personal and card info" do
      let(:charge) { double(:charge, successful?: true) }
      before { StripeWrapper::Charge.should_receive(:create).and_return(charge) }

      it "creates the user" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(User.count).to eq(1)
      end

      it "saves the user into a session" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(assigns(:user).id).to eq(session[:user_id])
      end

      it "makes the user follow the inviter" do
        bob = Fabricate(:user)
        bill = Fabricate.attributes_for(:user, email: 'bill@example.com', full_name: 'Bill Boe')
        invitation = Fabricate(:invitation, recipient_email: 'bill@example.com', recipient_name: 'Bill Boe', inviter: bob)
        post :create, user: bill, invitation_token: invitation.token
        expect(assigns(:user).follows?(bob)).to be_truthy
      end

      it "makes the inviter follow the user" do
        bob = Fabricate(:user)
        bill = Fabricate.attributes_for(:user, email: 'bill@example.com', full_name: 'Bill Boe')
        invitation = Fabricate(:invitation, recipient_email: 'bill@example.com', recipient_name: 'Bill Boe', inviter: bob)
        post :create, user: bill, invitation_token: invitation.token
        expect(bob.follows?(assigns(:user))).to be_truthy
      end

      it "expires the invitation upon acceptance" do
        bob = Fabricate(:user)
        bill = Fabricate.attributes_for(:user, email: 'bill@example.com', full_name: 'Bill Boe')
        invitation = Fabricate(:invitation, recipient_email: 'bill@example.com', recipient_name: 'Bill Boe', inviter: bob)
        post :create, user: bill, invitation_token: invitation.token
        expect(invitation.reload.token).to be_nil
      end

      it "redirects to home path" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to home_path
      end
    end

    context "with invalid personal info" do
      before { ActionMailer::Base.deliveries.clear }

      it "does not create the user" do
        post :create, user: { email: 'example@myflix.com', password: 'password' }
        expect(User.count).to eq(0)
      end

      it "it renders the :new template" do
        post :create, user: { email: 'example@myflix.com', password: 'password' }
        expect(response).to render_template :new
      end

      it "sets @user" do
        post :create, user: { email: 'example@myflix.com', password: 'password' }
        expect(assigns(:user)).to be_a_new(User)
      end

      it "does not charge the card" do
        StripeWrapper::Charge.should_not_receive(:charge)
        post :create, user: { email: 'example@myflix.com', password: 'password' }
      end

      it "does not send an email with invalid inputs" do
        post :create, user: { email: 'bob@myflix.com', password: 'password' }
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    context "with valid personal info and invalid card info" do
      let(:charge) { double(:charge, successful?: false, error_message: 'Your card was declined.') }
      before { StripeWrapper::Charge.should_receive(:create).and_return(charge) }

      it "does not create the user" do
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '12345'
        expect(User.count).to eq(0)
      end

      it "renders the new template" do
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '12345'
        expect(response).to render_template :new
      end

      it "sets the flash danger message" do
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '12345'
        expect(flash[:danger]).to eq('Your card was declined.')
      end
    end

    context "sending emails" do
      let(:charge) { double(:charge, successful?: true) }
      before do
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        ActionMailer::Base.deliveries.clear
      end

      after { ActionMailer::Base.deliveries.clear }

      it "sends an email to the user with valid inputs" do
        post :create, user: { email: 'bob@myflix.com', password: 'password', full_name: 'bob doe' }
        expect(ActionMailer::Base.deliveries.last.to).to eq(['bob@myflix.com'])
      end

      it "sends an email containing the user name with valid inputs" do
        post :create, user: { email: 'bob@myflix.com', password: 'password', full_name: 'bob doe' }
        expect(ActionMailer::Base.deliveries.last.body).to include('bob doe')
      end
    end
  end

  describe "GET show" do
    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: 1 }
    end

    it "assigns @user" do
      bob = Fabricate(:user)
      set_current_user
      get :show, id: bob.id
      expect(assigns(:user)).to eq(bob)
    end
  end
end