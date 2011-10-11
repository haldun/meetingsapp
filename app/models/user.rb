class User < ActiveRecord::Base
  has_secure_password

  attr_accessible :email, :password, :password_confirmation

  has_many :owned_rooms, :class_name => "Room", :foreign_key => "owner_id", :dependent => :destroy
  has_many :memberships, :dependent => :destroy
  has_many :rooms, :through => :memberships
  has_many :invitations, :dependent => :destroy
  has_many :authentications, :dependent => :destroy

  before_create { generate_token(:auth_token) }

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def to_s
    name || email
  end

  def apply_omniauth(omniauth)
    self.email = omniauth['user_info']['email'] if email.blank?
    self.name = omniauth['user_info']['name'] if name.blank?
    self.password = self.password_confirmation = SecureRandom.urlsafe_base64
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end
end
