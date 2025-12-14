class Public::FavoritesController < ApplicationController

  def create
    comment = Comment.find(params[:comment_id])
    favorite = current_user.favorites.new(comment_id: comment.id)
    favorite.save
    redirect_to item_review_path(review.item, review)
  end

  def destroy
    comment = Comment.find(params[:comment_id])
    favorite = current_user.favorites.find_by(comment_id: comment.id)
    favorite.destroy
    redirect_to item_review_path(review.item, review)
  end

end
