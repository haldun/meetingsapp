class Room < ActiveRecord::Base
  belongs_to :owner, :class_name => "User", :foreign_key => "owner_id"
  has_many :memberships, :dependent => :destroy
  has_many :admins, :through => :memberships, :class_name => "User", :source => :user,
                    :conditions => 'memberships.role = "admin"'
  has_many :members, :through => :memberships, :class_name => "User", :source => :user
  has_many :invitations, :dependent => :destroy

  validates_presence_of :name

  before_create { generate_token(:token) }

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64(32)
    end while Room.exists?(column => self[column])
  end
end
