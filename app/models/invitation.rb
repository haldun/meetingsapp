class Invitation < ActiveRecord::Base
  belongs_to :user
  belongs_to :room

  before_create { self.token = SecureRandom.urlsafe_base64 }
end
