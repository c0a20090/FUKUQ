class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "ようこそ、FUKUQへ"
      redirect_to @user
    else
      render 'new', status: :unprocessable_entity
    end
  end

  private

  # :user属性を必須とし、名前、メールアドレス、パスワード、パスワードの確認の属性をそれぞれ許可し、それ以外は許可しない。
  # 許された属性のみが含まれたハッシュを返す。
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
    end
end
