class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @question   = current_user.questions.build
      @q = current_user.feed.ransack(params[:q])
      @feed_items = @q.result.page(params[:page])
      @url = root_path
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
