class PicturesController < ApplicationController
  before_action :set_picture, only: [:show, :edit, :update, :destroy]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    @pictures = Picture.all
  end

  def new
    if params[:back]
      @picture = Picture.new(picture_params)
    else
      @picture = Picture.new
    end
  end

  def create
    @picture = current_user.pictures.build(picture_params)
    if @picture.save
      PictureMailer.picture_mail(@picture).deliver
      redirect_to pictures_path, notice: "投稿が完了しました！"
    else
      render 'new'
    end
  end

  def show
    @favorite = current_user.favorites.find_by(picture_id: @picture.id)
  end

  def edit
  end

  def update
    if @picture.update(picture_params)
      redirect_to pictures_path, notice: "編集しました！"
    else
      render 'edit'
    end
  end

  def destroy
    @picture.destroy
    redirect_to pictures_path, notice: "削除しました！"
  end

  def confirm
    @picture = Picture.new(picture_params)
    @picture.user_id = current_user.id
    render :new if @picture.invalid?
  end

  private

  def picture_params
    params.require(:picture).permit(:content, :image, :image_cache)
  end

  def set_picture
    @picture = Picture.find(params[:id])
  end

  def ensure_correct_user
    return if @picture.user_id == current_user.id
    flash[:notice] = "権限がありません！"
    redirect_to pictures_path
  end
end
