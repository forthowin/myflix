require 'spec_helper'

describe RelationshipsController do
  describe "GET index" do
    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end

    it "assigns @relationships as the relationships belonging to the current user" do
      bob = Fabricate(:user)
      set_current_user(bob)
      bill = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: bob, leader: bill)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end
  end

  describe "DELETE destroy" do
    it_behaves_like "requires sign in" do
      let(:action) {delete :destroy, id: 1 }
    end

    it "redirects to the people page" do
      bob = Fabricate(:user)
      set_current_user(bob)
      bill = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: bill, follower: bob)
      delete :destroy, id: relationship
      expect(response).to redirect_to people_path
    end

    it "deletes the relationship if the current user is a follower" do
      bob = Fabricate(:user)
      set_current_user(bob)
      bill = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: bill, follower: bob)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(0)
    end

    it "does not delete the relationship if the follower is not the current user" do
      bob = Fabricate(:user)
      bill = Fabricate(:user)
      set_current_user(bill)
      relationship = Fabricate(:relationship, leader: bill, follower: bob)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(1)
    end

  end
end

