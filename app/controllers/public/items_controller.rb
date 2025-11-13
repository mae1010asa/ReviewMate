class Public::ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
    @items = Item.all
    @items = Item.includes(:reviews).all
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
      flash.now[:alert] = 'ページの作成に失敗しました。入力内容をご確認ください。'
      render 'index'
    end
  end

private


def item_params
  params.require(:item).permit(:title, :body, :item_image)
end

end
