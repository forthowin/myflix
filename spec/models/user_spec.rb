require "spec_helper"

describe User do
  it { should validate_presence_of(:full_name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:queue_items).order(:position) }

  describe "#queued_video?" do
    it "returns true if the video is already in the queue" do
      bob = Fabricate(:user)
      futurama = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user: bob, video: futurama)
      expect(bob.queued_video?(futurama)).to be_truthy
    end

    it "returns false if the video is not in the queue" do
      bob = Fabricate(:user)
      futurama = Fabricate(:video)
      expect(bob.queued_video?(futurama)).to be_falsey
    end
  end
end