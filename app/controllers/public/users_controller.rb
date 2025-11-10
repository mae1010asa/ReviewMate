class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_not_guest_user, only: [:destroy]

  def mypage
    @user = current_user
    @reviews = @user.reviews
  end

  def show
    @user = current_user
  end
  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "レビューを更新しました。"
    else
      flash.now[:alert] = '更新に失敗しました。'
      render :edit
    end
  end

  def destroy
    if @user == current_user
      @user.destroy
      sign_out(current_user)
      redirect_to root_path, notice: '退会しました。'
    end
  end


  private

  def user_params
    params.require(:user).permit(:name, :email)
  end

  # --- ▼ ゲストユーザー削除防止 ▼ ---
  def ensure_not_guest_user
    @user = User.find(params[:id])
    if @user.email == User::GUEST_USER_EMAIL
      redirect_to user_path(@user), alert: 'ゲストユーザーは退会できません。'
    end
  end

end