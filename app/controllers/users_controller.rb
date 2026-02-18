class UsersController < ApplicationController
  before_action :login_user, only: [:show, :update, :destroy, :edit, :favorite_index]
  before_action :set_user, only: [:show, :update, :destroy, :edit, :favorite_index]
  before_action :authorize_current_user, only: [:show, :update, :destroy, :edit]

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
      redirect_to user_path ,notice: "プロフィールを編集しました！"
    else
      render 'edit'
    end
  end

  def destroy
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation,:image,:image_cache)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def authorize_current_user
    authorize_user(@user)
  end

end
