class Public::ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  skip_before_action :authenticate_user!, if: :admin_signed_in?

  def index
    @q = Item.ransack(params[:q])
  # 検索結果を取得
  items_results = @q.result(distinct: true)
  # ソート機能の分岐
  if params[:sort] == 'count'
    # レビュー件数の多い順
    @items = items_results.left_joins(:reviews)
                          .group(:id)
                          .order('COUNT(reviews.id) DESC')
  elsif params[:sort] == 'rating'
    # 評価の高い順
    # left_joinsを使うことで、レビューがない商品も表示リストから消えない
    @items = items_results.left_joins(:reviews)
                          .group(:id)
                          .order('AVG(reviews.star) DESC')
  else params[:sort] == 'latest'
    # 最新順
    @items = items_results.order(created_at: :desc)
  end
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      # 保存が成功した場合、該当するアイテムの詳細ページ (item_path) へリダイレクト
      redirect_to item_path(@item), notice: '商品を追加しました。'
    else
      @items = Item.all
      @items = Item.includes(:reviews).all
      # 保存が失敗した場合、# newを再表示します
      flash[:alert] = 'ページの作成に失敗しました。入力内容をご確認ください。'
      render 'index'
    end
  end

private


def item_params
  params.require(:item).permit(:title, :body, :item_image)
end

end
