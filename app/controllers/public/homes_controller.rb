class Public::HomesController < ApplicationController
  def top
    @q = Review.ransack(params[:q])
  end
  def about
  end
end
