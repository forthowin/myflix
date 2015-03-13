require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "renders the new template for unauthenticated users" do
      get :new
      expect(response).to render_template :new
    end

    it "redirects to home_path for autenticated users" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe "POST create" do
    context "with valid credentials" do
      let(:bob) { Fabricate(:user) }
      before { post :create, email: bob.email, password: bob.password }

      it "sets the session id as the signed in user" do
        expect(session[:user_id]).to eq(bob.id)
      end

      it "redirects to home path" do
        expect(response).to redirect_to home_path
      end

      it "sets the flash success message" do
        expect(flash[:success]).not_to be_blank
      end
    end

    context "with invalid credentials" do
      let(:bob) { Fabricate(:user) }
      before { post :create, email: bob.email, password: bob.password + 'asdf' }

      it "does not set the session id" do
        expect(session[:user_id]).to be_nil
      end

      it "redirects to sign in path" do
        expect(response).to redirect_to sign_in_path
      end

      it "sets the flash danger message" do
        expect(flash[:danger]).not_to be_blank
      end
    end
  end

  describe "GET destroy" do
    before do 
      set_current_user
      get :destroy
    end

    it "sets session id to nil" do
      expect(session[:user_id]).to be_nil
    end

    it "redirects to root path" do
      expect(response).to redirect_to root_path
    end

    it "sets the flash success message" do
      expect(flash[:success]).not_to be_blank
    end
  end
end