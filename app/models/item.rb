class Item < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_one_attached :item_image

  validates :title,presence:true

  def get_item_image
    if item_image.attached?
      item_image
    else
      'no_image.jpg'
    end
  end

  # Ransackの設定：ItemからReview、そしてReviewからTagへの検索を許可
  def self.ransackable_associations(auth_object = nil)
    ["reviews"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["body", "created_at", "id", "title", "updated_at"]
  end

end
