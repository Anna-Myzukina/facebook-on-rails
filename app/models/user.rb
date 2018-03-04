class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]
         
  has_many :posts, dependent: :destroy
  has_many :posts_authored, class_name: "Post",
                            foreign_key: :poster_id,
                            dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
  
  has_many :reverse_friendships, class_name: "Friendship",
                                 foreign_key: :friend_id,
                                 dependent: :destroy
  has_many :reverse_friends, class_name: "User",
                             through: :reverse_friendships,
                             source: :user
  
         
  validates :last_name, presence: true,
                        length: { maximum: 50 }
  validates :first_name, presence: true,
                         length: { maximum: 50 }
  validates :gender, presence: true
  validates :birthday, presence: true
  validates :username, presence: true,
                       length: { maximum: 20 },
                       format: { with: /\A[\w]+\z/},
                       uniqueness: { case_sensitive: false }
  
  enum gender: [:male, :female, :other, :not_telling]
  
  def add_as_friend!(user)
    self.friends << user
    self.reverse_friends << user
  end
  
  def unfriend!(user)
    self.friends.delete(user)
    self.reverse_friends.delete(user)
  end
  
  def friends_with?(user)
    friends.include? user
  end
  
  def to_param
    username
  end
  
  def self.search(query)
    return [] if query.blank?
    if query =~ /@/
      where(email: query)
    else
      where("concat_ws(' ', first_name, last_name, first_name, username) ILIKE ?", "%#{query.squish}%")
    end
  end
  
  def self.find_by_username(username)
    where("LOWER(username) = ?", username.downcase).first
  end
  
  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first
    
    # unless user
    #  user = User.new(email: data['email'])
    # end
    user
  end
end
