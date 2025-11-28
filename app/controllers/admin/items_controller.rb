class Admin::ItemsController < ApplicationController
  before_action :authenticate_admin!
  def index
    @items = Item.all
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      flash[:notice] = "商品情報を更新しました。"
      redirect_to admin_items_path
    else
      flash[:alert] = "商品情報の更新に失敗しました。"
      render "edit"
    end
  end


  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    redirect_to admin_items_path, notice: 'アイテムを削除しました。'
  end

  private

  def item_params
    params.require(:item).permit(:title, :body, :item_image)
  end

end
