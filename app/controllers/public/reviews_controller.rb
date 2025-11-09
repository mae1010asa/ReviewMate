class Public::ReviewsController < ApplicationController
  def new
    @item = Item.find(params[:item_id])
    @review = Review.new
  end

  def create
    @item = Item.find(params[:item_id])
    @review = @item.reviews.new(review_params)
    @review.user_id = current_user.id
    if @review.save
      # 保存が成功した場合、該当するアイテムの詳細ページ (item_path) へリダイレクト
      redirect_to item_path(@item), notice: 'レビューを投稿しました。'
    else
      # 保存が失敗した場合、# newを再表示します
      flash.now[:alert] = '投稿に失敗しました。入力内容をご確認ください。'
      render :new, status: :unprocessable_entity
    end
  end

  def index
  end

  def show
  end

  def edit
  end
end

private

  def review_params
    params.require(:review).permit(:title, :body)
  end
