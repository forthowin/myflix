require 'spec_helper'

describe VideosController do

  context "with authenticated user" do
    before do
      session[:user_id] = Fabricate(:user).id
    end

    describe "GET show" do
      it "assigns @video" do
        video = Fabricate(:video)
        get :show, id: video.id
        expect(assigns(:video)).to eq(video)
      end
      
      it "renders the show template" do
        video = Fabricate(:video)
        get :show, id: video.id
        expect(response).to render_template :show
      end
    end

    describe "GET search" do
      it "assigns @videos" do
        futurama = Fabricate(:video, title: 'Futurama')
        get :search, search_term: 'rama'
        expect(assigns(:videos)).to eq([futurama])
      end

      it "renders the search template" do
        futurama = Fabricate(:video, title: 'Futurama')
        get :search, search_term: 'rama'
        expect(response).to render_template :search
      end
    end
  end

  context "with unauthenticated user" do
    describe "GET show" do
      it "redirects to sign in page" do
        video = Fabricate(:video)
        get :show, id: video.id
        expect(response).to redirect_to sign_in_path
      end
    end

    describe "GET search" do
      it "redirects to sign in page" do
        futurama = Fabricate(:video, title: 'Futurama')
        get :search, search_term: 'rama'
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end
