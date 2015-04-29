require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like "requires admin" do
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

  describe "POST create" do
    it_behaves_like "requires admin" do
      let(:action) { post :create }
    end

    it_behaves_like "requires admin" do
      let(:action) { post :create }
    end

    context "with valid input" do
      it "redirects to the new page" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { title: "Futurama", description: "funny", category_id: category.id}
        expect(response).to redirect_to new_admin_video_path
      end

      it "creates a video" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { title: "Futurama", description: "funny", category_id: category.id}
        expect(Video.count).to eq(1)
      end

      it "sets the flash success message" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { title: "Futurama", description: "funny", category_id: category.id}
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid input" do
      it "does not create a video" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { description: "funny", category_id: category.id}
        expect(Video.count).to eq(0)
      end

      it "assigns a @video" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { description: "funny", category_id: category.id}
        expect(assigns(:video)).to be_present
      end

      it "renders the new page" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { description: "funny", category_id: category.id}
        expect(response).to render_template :new
      end

      it "sets the flash danger message" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { description: "funny", category_id: category.id}
        expect(flash[:danger]).to be_present
      end
    end
  end
end