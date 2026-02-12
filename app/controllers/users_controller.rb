class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update, :destroy, :favorite_index]
  before_action :ensure_correct_user, only: [:show, :edit, :update, :destroy, :favorite_index]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to new_session_path(@user.id), notice: "登録が完了しました。ログインしてください。"
    else
      render 'new'
    end
  end

  def show
    @favorites_pictures = @user.favorite_pictures
  end

  def favorite_index
    @favorites_pictures = @user.favorite_pictures
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "プロフィールを編集しました！"
    else
      render 'edit'
    end
  end

  def destroy
    # TODO: ユーザー削除機能を実装する場合は @user.destroy とルート追加
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation, :image, :image_cache)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def ensure_correct_user
    return if @user.id == current_user.id
    flash[:notice] = "権限がありません！"
    redirect_to pictures_path
  end
end
