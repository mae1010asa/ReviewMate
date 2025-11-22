class Public::ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  skip_before_action :authenticate_user!, if: :admin_signed_in?

  def index
    @items = Item.includes(:reviews).all
    @q = Item.ransack(params[:q])

    if params[:q].present?
      # 検索がある場合
      @items = @q.result(distinct: true).order(created_at: :desc)
    else
      # 検索がない場合（通常の一覧）
      @items = Item.all.order(created_at: :desc)
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
