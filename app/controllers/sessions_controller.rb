class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        forwarding_url = session[:forwarding_url]
        reset_session
        # チェックされてたら1,されてなかったら0
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        log_in user
        redirect_to forwarding_url || user
      else
        message  = "アカウントが有効ではありません。"
        message += "メールに記載されている有効化リンクをご確認ください。"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'メールアドレスもしくはパスワードが間違っています。'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    flash[:success] = "ログアウトしました"
    redirect_to root_url, status: :see_other
  end
end
