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
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe "POST create" do
    context "with valid input" do
      before do
        post :create, user: Fabricate.attributes_for(:user) #creates a :user in memory
      end

      it "creates the user" do
        expect(User.count).to eq(1)
      end

      it "redirects to home path" do
        expect(response).to redirect_to home_path
      end
    end

    context "with invalid input" do
      before do
        post :create, user: { email: 'example@myflix.com', password: 'password' }
      end

      it "does not create the user" do
        expect(User.count).to eq(0)
      end

      it "it renders the :new template" do
        expect(response).to render_template :new
      end

      it "sets @user" do
        expect(assigns(:user)).to be_a_new(User)
      end
    end
  end
end