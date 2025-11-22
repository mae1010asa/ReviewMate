class Public::ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item, only: [:new, :create]
  before_action :set_review_and_item, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, if: :admin_signed_in?

  def new
    @review = Review.new
  end

  def create
    @review = @item.reviews.new(review_params)
    @review.user_id = current_user.id
    if @review.save
      # 保存が成功した場合、該当するアイテムの詳細ページ (item_path) へリダイレクト
      redirect_to item_path(@item), notice: 'レビューを投稿しました。'
    else
      # 保存が失敗した場合、# newを再表示します
      flash[:alert] = '投稿に失敗しました。入力内容をご確認ください。'
      render :new, status: :unprocessable_entity
    end
  end

  def index
  end

  def show
  end

  def edit
    # 権限チェック
    unless @review.user == current_user
      redirect_to item_path(@item), alert: '編集する権限がありません。'
    end
  end

  def update
    # 権限チェック
    if @review.user != current_user
      redirect_to item_path(@item), alert: '更新する権限がありません。'
      return
    end
    if @review.update(review_params)
      redirect_to item_review_path(@item, @review), notice: "レビューを更新しました。"
    else
      flash[:alert] = '更新に失敗しました。入力内容をご確認ください。'
      render :edit
    end
  end

  def destroy
    if @review.user == current_user
      @review.destroy
      redirect_to item_path(@item), notice: 'レビューを削除しました。'
    else
      redirect_to mypage_path(@review.user), alert: '削除する権限がありません。'
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