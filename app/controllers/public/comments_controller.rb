class Public::CommentsController < ApplicationController
  before_action :authenticate_user!
    def create
      review = Review.find(params[:review_id])
      comment = current_user.comments.new(comment_params)
      comment.review_id = review.id
    if comment.save
      redirect_to item_review_path(review.item, review), notice: 'コメントを投稿しました。'
    else
      redirect_to item_review_path(review.item, review), alert: 'コメントに失敗しました。'
    end
  end


  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
