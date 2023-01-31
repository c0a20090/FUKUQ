class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "パスワード再設定メールを送信しました。メールをご確認ください。"
      redirect_to root_url
    else
      flash.now[:danger] = "無効なメールアドレスです。"
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty? 
      @user.errors.add(:password, "パスワードが空になっています。")
      render 'edit', status: :unprocessable_entity
    elsif @user.update(user_params) # user_paramsはeditで送られてきた値がほんまにパスとパス確だけか精査したparams
      reset_session
      log_in @user
      flash[:success] = "パスワードが再設定されました。"
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
      @user = User.find_by(email: params[:email])
    end

    # 正しいユーザーかどうか確認する(digestとtokenの比較)
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    # トークンが期限切れかどうかを確認する
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "リンクの有効期限が切れています。"
        redirect_to new_password_reset_url
      end
    end
end
