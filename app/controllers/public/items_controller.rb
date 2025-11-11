class Public::ItemsController < ApplicationController
  def index
    @items = Item.all
    @items = Item.includes(:reviews).all
  end

  def show
    @item = Item.find(params[:id])
  end
end

def item_params
  params.require(:item).permit(:title, :body, :item_image)
end
