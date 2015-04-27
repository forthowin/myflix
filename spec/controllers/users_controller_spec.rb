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
    context "successful user sign up" do
      it "saves the user id into the session" do
        result = double(:sign_up_result, successful?: true, user_id: 1)
        allow_any_instance_of(UserSignup).to receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
        expect(session[:user_id]).to eq(1)
      end

      it "redirects to home path" do
        result = double(:sign_up_result, successful?: true, user_id: 1)
        allow_any_instance_of(UserSignup).to receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to home_path
      end
    end

    context "failed user sign up" do
      it "renders the new template" do
        result = double(:sign_up_result, successful?: false, error_message: "some error message")
        allow_any_instance_of(UserSignup).to receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to render_template :new
      end

      it "sets the flash danger message" do
        result = double(:sign_up_result, successful?: false, error_message: "some error message")
        allow_any_instance_of(UserSignup).to receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
        expect(flash[:danger]).to eq(result.error_message)
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