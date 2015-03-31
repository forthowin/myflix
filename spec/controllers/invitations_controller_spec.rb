require 'spec_helper'

describe InvitationsController do
  describe "GET new" do
    it "assigns @invitation as a new invitation" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_a_new(Invitation)
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end
  end

  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create }
    end

    context "with valid inputs" do
      after { ActionMailer::Base.deliveries.clear }

      it "creates an invitation" do
        set_current_user
        post :create, invitation: Fabricate.attributes_for(:invitation)
        expect(Invitation.count).to eq(1)
      end

      it "sends an email to the recipient" do
        set_current_user
        post :create, invitation: Fabricate.attributes_for(:invitation)
        expect(ActionMailer::Base.deliveries.last.to).to eq([Invitation.first.recipient_email])
      end

      it "redirects to invitation new page" do
        set_current_user
        post :create, invitation: Fabricate.attributes_for(:invitation)
        expect(response).to redirect_to invite_path
      end

      it "sets the flash success message" do
        set_current_user
        post :create, invitation: Fabricate.attributes_for(:invitation)
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid inputs" do
      it "renders the invite page" do
        set_current_user
        post :create, invitation: Fabricate.attributes_for(:invitation, recipient_name: "")
        expect(response).to render_template :new
      end

      it "does not create an invitation" do
        set_current_user
        post :create, invitation: Fabricate.attributes_for(:invitation, recipient_name: "")
        expect(Invitation.count).to eq(0)
      end

       it "sets an @invitation" do
        set_current_user
        post :create, invitation: Fabricate.attributes_for(:invitation, recipient_name: "")
        expect(assigns(:invitation)).to be_a_new(Invitation)
      end

      it "does not send an email" do
        set_current_user
        post :create, invitation: Fabricate.attributes_for(:invitation, recipient_name: "")
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end