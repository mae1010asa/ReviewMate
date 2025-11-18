class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_not_guest_user, only: [:update, :destroy]

  def mypage
    @user = current_user
    @reviews = @user.reviews
  end

  def show
    @user = User.find(params[:id])
  end
  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "ユーザー情報を更新しました。"
    else
      flash[:alert] = '更新に失敗しました。'
      render :edit
    end
  end

  def destroy
    if @user == current_user
      @user.destroy
      sign_out(current_user)
      redirect_to new_user_registration_path, notice: '退会しました。'
    end
  end

  def followings
    user = User.find(params[:id])
    @users = user.followings
  end

  def followers
    user = User.find(params[:id])
    @users = user.followers
  end



  private

  def user_params
    params.require(:user).permit(:name, :email)
  end

  # --- ▼ ゲストユーザー削除防止 ▼ ---
  def ensure_not_guest_user
    @user = User.find(params[:id])
    if @user.email == User::GUEST_USER_EMAIL
      redirect_to user_path(@user), alert: 'ゲストユーザーではこの処理ができません。'
    end
  end

end