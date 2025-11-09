class AddItemIdToReviews < ActiveRecord::Migration[6.1]
  def change
    add_column :reviews, :item_id, :integer
  end
end
