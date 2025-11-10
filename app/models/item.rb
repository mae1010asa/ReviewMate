class Item < ApplicationRecord
  has_many :reviews, dependent: :destroy

end
