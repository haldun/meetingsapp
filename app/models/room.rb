class Room < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  belongs_to :owner, :class_name => "User", :foreign_key => "owner_id"
  has_many :memberships, :dependent => :destroy
  has_many :admins, :through => :memberships, :class_name => "User", :source => :user,
                    :conditions => 'memberships.role = "admin"'
  has_many :members, :through => :memberships, :class_name => "User", :source => :user
  has_many :invitations, :dependent => :destroy

  validates_presence_of :name

  before_create { generate_token(:token) }
  after_save { Rails.cache.write("rooms/#{id}", self) }
  after_destroy { Rails.cache.delete("rooms/#{id}") }

  def self.fetch(id)
    Rails.cache.fetch("rooms/#{id}") { find(id) }
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64(32)
    end while Room.exists?(column => self[column])
  end

  def join!(user)
    REDIS.zadd(redis_key(:online_users), user.id, Time.now.utc)
  end

  def leave!(user)
    REDIS.srem(redis_key(:online_users), user.id)
  end

  def online_users
    @online_users ||= begin
      user_ids = REDIS.smembers(redis_key(:online_users))
      user_ids.present? ? User.where(:id => user_ids) : []
    end
  end

  def redis_key(prefix)
    "rooms/#{self.id}/#{prefix}"
  end

  memoize :redis_key
end
