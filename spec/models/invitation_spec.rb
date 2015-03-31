require 'spec_helper'

describe Invitation do
  it { should belong_to(:inviter) }
  it { should validate_presence_of(:recipient_email) }
  it { should validate_presence_of(:recipient_name) }
  it { should validate_presence_of(:message) }
  it { should validate_presence_of(:inviter_id) }

  it "generates a random token upon creation" do
    invitation = Fabricate(:invitation)
    expect(invitation.token).to be_present
  end
end