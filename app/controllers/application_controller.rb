class ApplicationController < ActionController::Base
  include SessionsHelper

  private

    # ユーザーのログインを確認する
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください。"
        redirect_to login_url, status: :see_other
      end
    end

    def questions_search_params
      params.require(:q).permit(:title_cont)
    end
end
