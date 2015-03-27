require "spec_helper"

describe User do
  it { should validate_presence_of(:full_name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:queue_items).order(:position) }
  it { should have_many(:reviews).order("created_at DESC") }

  it "generates a random token when a user is created" do
    bob = Fabricate(:user)
    expect(bob.token).to be_present
  end

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

  describe "#follows?" do
    it "returns true if the current user is following another user" do
      bob = Fabricate(:user)
      bill = Fabricate(:user)
      Fabricate(:relationship, leader: bill, follower: bob)
      expect(bob.follows?(bill)).to be_truthy
    end

    it "returns false if the current user is not following another user" do
      bob = Fabricate(:user)
      bill = Fabricate(:user)
      Fabricate(:relationship, leader: bob, follower: bill)
      expect(bob.follows?(bill)).to be_falsey
    end
  end
end