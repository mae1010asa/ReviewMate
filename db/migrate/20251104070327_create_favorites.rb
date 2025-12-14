class CreateFavorites < ActiveRecord::Migration[6.1]
  def change
    create_table :favorites do |t|
      t.integer :user_id, null: false
      t.integer :comment_id, null: false
      t.timestamps
    end
    add_index :favorites, [:user_id, :comment_id], unique: true
  end
end
