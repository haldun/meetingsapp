class Room < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  belongs_to :owner, :class_name => "User", :foreign_key => "owner_id"
  has_many :memberships, :dependent => :destroy
  has_many :admins, :through => :memberships, :class_name => "User", :source => :user,
                    :conditions => 'memberships.role = "admin"'
  has_many :members, :through => :memberships, :class_name => "User", :source => :user
  has_many :invitations, :dependent => :destroy
  has_many :messages, :dependent => :destroy

  validates_presence_of :name

  before_create { self.token = SecureRandom.urlsafe_base64(32) }
  after_save { Rails.cache.write("rooms/#{id}", self) }
  after_destroy { Rails.cache.delete("rooms/#{id}") }

  def self.fetch(id)
    Rails.cache.fetch("rooms/#{id}") { find(id) }
  end

  def join!(user)
    REDIS.zadd(redis_key(:online_users), Time.now.utc.to_f, user.id)
    @online_users = nil
  end

  def leave!(user)
    REDIS.zrem(redis_key(:online_users), user.id)
    @online_users = nil
  end

  def online_users_count
    REDIS.zcount(redis_key(:online_users), 0, Time.now.utc.to_f)
  end

  def online_users
    # TODO Query does not preserve the order in redis, so we need to order
    # the returned users row set.
    @online_users ||= begin
      user_ids = REDIS.zrangebyscore(redis_key(:online_users), 0, Time.now.utc.to_f)
      user_ids.present? ? User.where(:id => user_ids) : []
    end
  end

  def redis_key(prefix)
    "rooms/#{self.id}/#{prefix}"
  end

  def to_s
    name
  end

  memoize :redis_key
end
