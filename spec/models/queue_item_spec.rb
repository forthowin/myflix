require "spec_helper"

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:video) }
  
  describe "#video_title" do
    it "returns the title of the associated video" do
      bob = Fabricate(:user)
      futurama = Fabricate(:video, title: 'futurama')
      queue_item = Fabricate(:queue_item, user: bob, video: futurama)
      expect(queue_item.video_title).to eq('futurama')
    end
  end

  describe "#rating" do
    it "returns the rating of the associated video when the review is present" do
      bob = Fabricate(:user)
      futurama = Fabricate(:video, title: 'futurama')
      review = Fabricate(:review, rating: 5, user: bob, video: futurama)
      queue_item = Fabricate(:queue_item, user: bob, video: futurama)
      expect(queue_item.rating).to eq(5)
    end

    it "returns nil when the review is not present" do
      bob = Fabricate(:user)
      futurama = Fabricate(:video, title: 'futurama')
      queue_item = Fabricate(:queue_item, user: bob, video: futurama)
      expect(queue_item.rating).to eq(nil)
    end
  end

  describe "#category_name" do
    it "returns the category name associated with the video" do
      bob = Fabricate(:user)
      comedy = Fabricate(:category, name: 'comedy')
      futurama = Fabricate(:video, title: 'futurama', category: comedy)
      queue_item = Fabricate(:queue_item, user: bob, video: futurama)
      expect(queue_item.category_name).to eq('comedy')
    end
  end

  describe "#category" do
    it "returns the category associated with the video" do
      bob = Fabricate(:user)
      comedy = Fabricate(:category, name: 'comedy')
      futurama = Fabricate(:video, title: 'futurama', category: comedy)
      queue_item = Fabricate(:queue_item, user: bob, video: futurama)
      expect(queue_item.category).to eq(comedy)
    end
  end
end