class Public::UsersController < ApplicationController
  before_action :authenticate_user!, only: [:mypage,:edit,:update, :destroy, :show]
  before_action :ensure_not_guest_user, only: [:update, :destroy]


  def index
    # Ransackによる検索実行
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true)
  end

  def mypage
    @user = current_user
    following_user_ids = current_user.following_ids
    @reviews = Review.where(user_id: following_user_ids)
                     .includes(:user, :item)
                     .order(created_at: :desc)
    @q = User.ransack(params[:q])
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
    @this_user = User.find(params[:id])
    @users = @this_user.followings
  end

  def followers
    @this_user = User.find(params[:id])
    @users = @this_user.followers
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