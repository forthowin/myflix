require "spec_helper"

describe QueueItemsController do

  describe "GET index" do
    it "assigns @queue_items associated with the signed in user" do
      bob = Fabricate(:user)
      video = Fabricate(:video)
      session[:user_id] = bob.id
      queue_item1 = Fabricate(:queue_item, user: bob, video: video)
      queue_item2 = Fabricate(:queue_item, user: bob, video: video)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end

    it "redirects to the sign in page for unauthenticated users" do
      get :index
      expect(response).to redirect_to(sign_in_path)
    end
  end

  describe "POST create" do
    it "redirects to my_queue page for authenticated user" do
      bob = Fabricate(:user)
      session[:user_id] = bob.id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(response).to redirect_to(my_queue_path)
    end

    it "creates a queue item" do
      bob = Fabricate(:user)
      session[:user_id] = bob.id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end

    it "creates a queue item associated with the current user" do
      bob = Fabricate(:user)
      session[:user_id] = bob.id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.user_id).to eq(bob.id)
    end

    it "creates a queue item associated with the video" do
      bob = Fabricate(:user)
      session[:user_id] = bob.id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.video_id).to eq(video.id)
    end

    it "puts the video as the last one in the queue" do
      bob = Fabricate(:user)
      session[:user_id] = bob.id
      video1 = Fabricate(:video)
      futurama = Fabricate(:video, title: 'futurama')
      Fabricate(:queue_item, user: bob, video: video1)
      post :create, video_id: futurama.id
      futurama_queue_item = QueueItem.where(user: bob, video: futurama).first
      expect(futurama_queue_item.position).to eq(2)
    end

    it "does not add the video to the queue if the video is alerady in the queue" do
      bob = Fabricate(:user)
      session[:user_id] = bob.id
      futurama = Fabricate(:video, title: 'futurama')
      Fabricate(:queue_item, user: bob, video: futurama)
      post :create, video_id: futurama.id
      expect(QueueItem.count).to eq(1)
    end

    it "redirects to the sign in page for unauthenticated user" do
      post :create
      expect(response).to redirect_to(sign_in_path)
    end

    it "sets the flash success message when a queue item is created" do
      bob = Fabricate(:user)
      session[:user_id] = bob.id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(flash[:success]).not_to be_blank
    end

    it "sets the flash danger message when a video is already in the queue" do
      bob = Fabricate(:user)
      session[:user_id] = bob.id
      futurama = Fabricate(:video, title: 'futurama')
      Fabricate(:queue_item, user: bob, video: futurama)
      post :create, video_id: futurama.id
      expect(flash[:danger]).not_to be_blank
    end
  end

  describe "DELETE destroy" do
    context "with authenticated users" do
      let(:bob) { Fabricate(:user) }
      let(:futurama) { Fabricate(:video) }

      before do
        session[:user_id] = bob.id
      end

      it "redirects to the my queue page" do
        queue_item = Fabricate(:queue_item, user: bob, video: futurama)
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to my_queue_path
      end

      it "deletes the queue item" do
        queue_item = Fabricate(:queue_item, user: bob, video: futurama)
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(0)
      end

      it "does not delete the queue item if the queue item belongs to another user's queue" do
        jim = Fabricate(:user)
        queue_item = Fabricate(:queue_item, user: jim, video: futurama)
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(1)
      end

      it "normalizes the remaining queue items" do
        queue_item1 = Fabricate(:queue_item, user: bob, video: futurama, position: 1)
        queue_item2 = Fabricate(:queue_item, user: bob, video: futurama, position: 2)
        delete :destroy, id: queue_item1.id
        expect(queue_item2.reload.position).to eq(1)
      end
    end

    it "redirects to the sign in page for unauthenticated users" do
      delete :destroy, id: 1
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "POST queue_update" do
    context "with valid inputs" do
      let(:bob) { Fabricate(:user) }
      let(:futurama) { Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, user: bob, video: futurama, position: 1) }
      let(:queue_item2) { Fabricate(:queue_item, user: bob, video: futurama, position: 2) }

      before do
        session[:user_id] = bob.id
      end

      it "redirects to my queue page" do
        post :queue_update, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(response).to redirect_to my_queue_path
      end

      it "reorders the queue item" do
        post :queue_update, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(bob.queue_items).to eq([queue_item2, queue_item1])
      end

      it "normalizes the position number" do
        post :queue_update, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(bob.queue_items.map(&:position)).to eq([1, 2])
      end
    end

    context "with invalid inputs" do
      let(:bob) { Fabricate(:user) }
      let(:futurama) { Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, user: bob, video: futurama, position: 1) }
      let(:queue_item2) { Fabricate(:queue_item, user: bob, video: futurama, position: 2) }

      before do
        session[:user_id] = bob.id
      end

      it "redirects to my queue page" do
        post :queue_update, queue_items: [{id: queue_item1.id, position: 3.1}, {id: queue_item2.id, position: 2}]
        expect(response).to redirect_to my_queue_path
      end

      it "sets the flash danger message" do
        post :queue_update, queue_items: [{id: queue_item1.id, position: 3.1}, {id: queue_item2.id, position: 2}]
        expect(flash[:danger]).to be_present
      end

      it "does not change the queue items" do
        post :queue_update, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2.1}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end

    context "with unauthenticated users" do
      it "redirects to the sign in page" do
        post :queue_update, queue_items: [{id: 1, position: 1}]
        expect(response).to redirect_to(sign_in_path)
      end
    end

    context "with queue item that does not belong to the current user" do
      it "does not change the queue items" do
        bob = Fabricate(:user)
        jim = Fabricate(:user)
        futurama = Fabricate(:video)
        session[:user_id] = bob.id
        queue_item1 = Fabricate(:queue_item, user: jim, video: futurama, position: 1)
        queue_item2 = Fabricate(:queue_item, user: jim, video: futurama, position: 2)
        post :queue_update, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end
  end
end
