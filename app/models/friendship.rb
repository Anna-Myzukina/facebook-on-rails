class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User"
  
  validates :user_id, uniqueness: { scope: :friend_id }
  validate :avoid_befriending_self
  
  def self.fetch(user1, user2)
    where(user: user1, friend: user2).first
  end
  
  private
  
    def avoid_befriending_self
      errors.add(:user_id, "cannot befriend itself.") if user_id == friend_id
    end
end