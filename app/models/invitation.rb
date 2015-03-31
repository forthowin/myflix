class Invitation < ActiveRecord::Base
  include Tokenable
  
  belongs_to :inviter, class_name: "User"

  validates_presence_of :recipient_email, :recipient_name, :message, :inviter_id

  before_create :generate_token
end