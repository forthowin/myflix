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

      it "saves the user into a session" do
        expect(assigns(:user).id).to eq(session[:user_id])
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

    context "sending emails" do
      after { ActionMailer::Base.deliveries.clear }

      it "sends an email to the user with valid inputs" do
        post :create, user: { email: 'bob@myflix.com', password: 'password', full_name: 'bob doe' }
        expect(ActionMailer::Base.deliveries.last.to).to eq(['bob@myflix.com'])
      end

      it "sends an email containing the user name with valid inputs" do
        post :create, user: { email: 'bob@myflix.com', password: 'password', full_name: 'bob doe' }
        expect(ActionMailer::Base.deliveries.last.body).to include('bob doe')
      end

      it "does not send an email with invalid inputs" do
        post :create, user: { email: 'bob@myflix.com', password: 'password' }
        expect(ActionMailer::Base.deliveries).to be_empty
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