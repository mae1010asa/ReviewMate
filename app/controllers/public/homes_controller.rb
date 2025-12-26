class Public::HomesController < ApplicationController
  def top
    @q = Review.ransack(params[:q])
    @reviews = Review.all.order(created_at: :desc).includes(:item)
  end
  def about
  end
end
