class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :reviews, dependent: :destroy
  has_many :comments, dependent: :destroy

  # フォローしている側の関係
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :followings, through: :active_relationships, source: :followed

  # フォローされている側の関係
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  
  validates :name, length: { maximum: 20 }, presence:true
  validates :email,presence:true

  GUEST_USER_EMAIL = "guest@example.com"

  has_one_attached :user_image

  # Ransackの設定：検索可能な属性を定義
  def self.ransackable_attributes(auth_object = nil)
    ["name", "created_at"] 
  end

  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲストユーザー"
    end
  end
  def get_user_image
    if user_image.attached?
      user_image
    else
      'no_image.jpg'
    end
  end

  def following?(user)
    followings.exists?(id: user.id)
  end

end
