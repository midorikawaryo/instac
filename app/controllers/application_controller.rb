class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  before_action :require_login

  private

  def require_login
    return if logged_in?
    redirect_to new_session_path, notice: "ログインしてください!"
  end
end
