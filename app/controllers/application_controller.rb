class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  # Redirect to login page if user is not logged in
  def login_user
    redirect_to new_session_path, notice: 'ログインしてください' if current_user.nil?
  end

  # Ensure passed user is the same as the current logged in user
  def authorize_user(user)
    if user != current_user
      flash[:notice] = '権限がありません！'
      redirect_to pictures_path
    end
  end
end
