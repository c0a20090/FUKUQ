class UsersController < ApplicationController
  before_action :logged_in_user,        only: [:index, :edit, :update, :destroy]
  before_action :correct_user,          only: [:edit, :update]
  # before_action :admin_or_current_user, only: :destroy
  before_action :admin_user,            only: :index
  
  def index
    @users = User.all.order(created_at: :asc).page(params[:page])
  end

  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = "アカウント有効化メールを送信しました。メールをご確認ください。"
      redirect_to root_url
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "プロフィールを更新しました"
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーを削除しました"
    redirect_to users_path, status: :see_other
  end

  private

  # :user属性を必須とし、名前、メールアドレス、パスワード、パスワードの確認の属性をそれぞれ許可し、それ以外は許可しない。
  # 許された属性のみが含まれたハッシュを返す。
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
    end

    # beforeフィルタ

    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください"
        redirect_to login_url, status: :see_other
      end
    end

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url, status: :see_other) unless current_user?(@user)
    end

    # 管理者か現在ログインしているユーザーかどうか確認
    # def admin_or_current_user
    #   redirect_to(root_url, status: :see_other) unless !current_user?(@user)
    # end

    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url, status: :see_other) unless current_user.admin?
    end
end
