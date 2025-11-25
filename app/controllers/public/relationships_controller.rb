class Public::RelationshipsController < ApplicationController

  def create
    user = User.find(params[:user_id])
    current_user.followings << user
    redirect_to request.referer
  end

  def destroy
    user = User.find(params[:user_id])
    current_user.followings.delete(user)
    redirect_to request.referer
  end


end
