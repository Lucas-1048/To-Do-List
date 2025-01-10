class HomeController < ApplicationController
  before_action :redirect_user

  def index
  end

  private

  def redirect_user
    if user_signed_in?
      redirect_to root_path unless request.path == root_path
    else
      redirect_to new_user_session_path
    end
  end
end
