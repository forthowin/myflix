module Tokenable
  extend ActiveSupport::Concern
  
  included do
    def generate_token
      self.token = SecureRandom.urlsafe_base64
    end
  end
end