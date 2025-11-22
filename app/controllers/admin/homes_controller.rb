class Admin::HomesController < ApplicationController
  before_action :authenticate_admin!

  def top
    @reviews = Review.all.order(created_at: :desc).includes(:item)
  end

end
