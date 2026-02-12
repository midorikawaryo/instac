class FavoritesController < ApplicationController
  def create
    favorite = current_user.favorites.create(picture_id: params[:picture_id])
    redirect_to pictures_url, notice: "#{favorite.picture.user.name}さんの投稿をお気に入り登録しました"
  end

  def destroy
    favorite = current_user.favorites.find_by(id: params[:id])
    return redirect_to pictures_url, notice: "お気に入りが見つかりません" unless favorite
    owner_name = favorite.picture.user.name
    favorite.destroy
    redirect_to pictures_url, notice: "#{owner_name}さんの投稿をお気に入り解除しました"
  end
end
