require 'spec_helper'

describe ResetPasswordsController do
  describe "GET show" do
    it "renders the template if the token is valid" do
      bob = Fabricate(:user)
      bob.update_column(:token, '1234')
      get :show, id: bob.token
      expect(response).to render_template :show
    end

    it "assigns @token" do
      bob = Fabricate(:user)
      bob.update_column(:token, '1234')
      get :show, id: bob.token
      expect(assigns(:token)).to eq(bob.token)
    end

    it "redirects to the invalid token page if the token is not valid" do
      bob = Fabricate(:user)
      bob.update_column(:token, '1234')
      get :show, id: '123'
      expect(response).to redirect_to invalid_token_path
    end
  end

  describe "POST create" do
    context "with valid token" do
      context "with valid password" do
        it "update the users's password" do
          bob = Fabricate(:user)
          bob.update_column(:token, '1234')
          post :create, token: '1234', password: 'new_password'
          expect(bob.reload.authenticate('new_password')).to be_truthy
        end

        it "redirects to the sign in page" do
          bob = Fabricate(:user)
          bob.update_column(:token, '1234')
          post :create, token: '1234', password: 'new_password'
          expect(response).to redirect_to sign_in_path
        end

        it "sets the flash success message" do
          bob = Fabricate(:user)
          bob.update_column(:token, '1234')
          post :create, token: '1234', password: 'new_password'
          expect(flash[:success]).to be_present
        end

        it "set the user's token to nil" do
          bob = Fabricate(:user)
          bob.update_column(:token, '1234')
          post :create, token: '1234', password: 'new_password'
          expect(bob.reload.token).to be_nil
        end
      end

      context "with invalid password" do
        it "sets the flash danger message" do
          bob = Fabricate(:user)
          bob.update_column(:token, '1234')
          post :create, token: '1234', password: ''
          expect(flash[:danger]).to be_present
        end

        it "redirects to the show page" do
          bob = Fabricate(:user)
          bob.update_column(:token, '1234')
          post :create, token: '1234', password: ''
          expect(response).to redirect_to reset_password_path('1234')
        end
      end
    end

    context "with invalid token" do
      it "redirects to the invalid token page" do
        post :create, token: '1234', password: 'new_password'
        expect(response).to redirect_to invalid_token_path
      end
    end
  end
end