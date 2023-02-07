class UsersController < ApplicationController
  before_action :logged_in_user,        only: [:index, :edit, :update,        :destroy, :following, :followers]
  before_action :correct_user,          only: [:edit, :update]
  before_action :admin_user,            only: [:index, :destroy]
  
  def index
    @q = User.ransack(params[:q])
    @users = @q.result.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @q = @user.questions.ransack(params[:q])
    @questions = @q.result.page(params[:page])
    @url = user_path(@user)
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
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

  def following
    @title = "フォロー"
    @user  = User.find(params[:id])
    @users = @user.following.page(params[:page])
    render 'show_follow', status: :unprocessable_entity
  end

  def followers
    @title = "フォロワー"
    @user  = User.find(params[:id])
    @users = @user.followers.page(params[:page])
    render 'show_follow', status: :unprocessable_entity
  end

  private

  # :user属性を必須とし、名前、メールアドレス、パスワード、パスワードの確認の属性をそれぞれ許可し、それ以外は許可しない。
  # 許された属性のみが含まれたハッシュを返す。
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
    end

    # beforeフィルタ

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url, status: :see_other) unless current_user?(@user)
    end

    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url, status: :see_other) unless current_user.admin?
    end
end
