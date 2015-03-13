require 'spec_helper'

describe ReviewsController do
  describe "POST create" do
    let(:video) { Fabricate(:video) }

    context "with authenticated users" do
      let(:bob) { Fabricate(:user) }
      before { set_current_user(bob) }

      context "with valid input" do
        it "redirects to the video show page" do
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
          expect(response).to redirect_to(video_path(video))
        end

        it "creates a review" do
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
          expect(Review.count).to eq(1)
        end

        it "creates a review associated with the video" do
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
          expect(Review.first.video).to eq(video)
        end

        it "creates a review associated with the user" do
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
          expect(Review.first.user).to eq(bob)
        end

        it "sets the flash success message" do
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
          expect(flash[:success]).not_to be_blank
        end
      end

      context "with invalid input" do
        it "does not create a review" do
          post :create, review: Fabricate.attributes_for(:review, content: ""), video_id: video.id
          expect(Review.count).to eq(0)
        end
        it "renders the video show template" do
          post :create, review: Fabricate.attributes_for(:review, content: ""), video_id: video.id
          expect(response).to render_template 'videos/show'
        end
        it "sets the flash danger message" do
          post :create, review: Fabricate.attributes_for(:review, content: ""), video_id: video.id
          expect(flash[:danger]).not_to be_blank
        end
        it "assigns @video" do
          post :create, review: Fabricate.attributes_for(:review, content: ""), video_id: video.id
          expect(assigns(:video)).to eq(video)
        end
        it "assigns @reviews" do
          review = Fabricate(:review, video: video)
          post :create, review: Fabricate.attributes_for(:review, content: ""), video_id: video.id
          expect(assigns(:reviews)).to match_array([review])
        end
      end
    end

    it_behaves_like "requires sign in" do
      let(:action) { post :create, review: Fabricate.attributes_for(:review), video_id: video.id }
    end
  end
end