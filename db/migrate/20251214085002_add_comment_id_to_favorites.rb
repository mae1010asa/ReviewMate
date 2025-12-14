class AddCommentIdToFavorites < ActiveRecord::Migration[6.1]
  def change
    add_column :favorites, :comment_id, :integer, null: false
    add_index :favorites, [:user_id, :comment_id], unique: true
  end
end
