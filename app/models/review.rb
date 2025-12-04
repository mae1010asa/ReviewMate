class Review < ApplicationRecord
  has_many :comments, dependent: :destroy
  belongs_to :user
  belongs_to :item
  validates :title, length: { maximum: 20 },presence:true
  validates :body, length: { maximum: 99 },presence:true
  validates :star,presence:true

  # タグ機能の有効化
  acts_as_taggable

  # Ransackの設定：検索可能な属性
  def self.ransackable_attributes(auth_object = nil)
    ["title", "created_at"] 
  end

  # Ransackの設定：検索可能な関連（タグへのアクセスを許可）
  def self.ransackable_associations(auth_object = nil)
    ["tags"]
  end

end
