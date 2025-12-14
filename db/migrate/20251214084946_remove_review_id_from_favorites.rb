class RemoveReviewIdFromFavorites < ActiveRecord::Migration[6.1]
  def change
    remove_column :favorites, :review_id, :integer
  end
end
