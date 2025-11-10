class Public::UsersController < ApplicationController
  before_action :authenticate_user!

  def mypage
    @user = current_user
    @reviews = @user.reviews
  end

  def show
  end
  def edit
  end
  def update
  end
  def destroy
  end
end

def user_params
  params.require(:user).permit(:name, :email)
end