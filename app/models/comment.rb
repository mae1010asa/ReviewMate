class Comment < ApplicationRecord
  belongs_to :review
  belongs_to :user
  has_many :favorites, dependent: :destroy
  validates :body,presence:true

  def favorited_by?(user)
    favorites.exists?(user_id: current_user.id)
  end

end
