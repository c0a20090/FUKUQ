class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "アカウントを有効化しました。"
      redirect_to user
    else
      flash[:danger] = "無効な有効化リンクです。"
      redirect_to root_url
    end
  end
end
