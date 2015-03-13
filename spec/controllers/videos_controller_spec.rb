require 'spec_helper'

describe VideosController do

  context "with authenticated user" do
    before { set_current_user }

    describe "GET show" do
      it "assigns @video" do
        video = Fabricate(:video)
        get :show, id: video.id
        expect(assigns(:video)).to eq(video)
      end

      it "assigns @review" do
        video = Fabricate(:video)
        review1 = Fabricate(:review, video: video)
        review2 = Fabricate(:review, video: video)
        get :show, id: video.id
        expect(assigns(:reviews)).to match_array([review1, review2])
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
      it_behaves_like "requires sign in" do
        let(:video) { Fabricate(:video) }
        let(:action) { get :show, id: video.id }
      end
    end

    describe "GET search" do
      it_behaves_like "requires sign in" do
        let(:futurama) { Fabricate(:video, title: 'Futurama') }
        let(:action) { get :search, search_term: 'rama' }
      end
    end
  end
end
