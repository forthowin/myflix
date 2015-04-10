require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end

    it "sets @video" do
      set_current_admin
      get :new
      expect(assigns(:video)).to be_a_new(Video)
    end

    it "redirects to home path for regular users" do
      set_current_user
      get :new
      expect(response).to redirect_to home_path
    end

    it "sets the flash danger message for regular users" do
      set_current_user
      get :new
      expect(flash[:danger]).to be_present
    end
  end
end