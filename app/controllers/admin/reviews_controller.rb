class Admin::ReviewsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_item
  before_action :set_review_and_item, only: [:show, :destroy]
  def show
  end

  def destroy
    if @review.destroy
      redirect_to admin_root_path, notice: 'レビューを削除しました。'
    else
      redirect_to admin_root_path, alert: '削除に失敗しました。'
    end
  end

end

private

  def review_params
    params.require(:review).permit(:title, :body, :star)
  end

  # :item_id から @item を見つける
  def set_item
    @item = Item.find(params[:item_id])
  end
  
  # :id から @review を見つけ、@review から @item を見つける
  def set_review_and_item
    @review = Review.find(params[:id])
    @item = @review.item
  end