class QuestionsController < ApplicationController
  before_action :logged_in_user, only: [:show, :new, :create, :destroy]
  before_action :correct_user,   only: :destroy

  def index
    @questions = Question.all.page(params[:page])
  end

  def show
    @question = Question.find(params[:id])
  end

  def new
    @question = current_user.questions.build if logged_in?
  end

  def create
    @question = current_user.questions.build(question_params)
    @question.image.attach(params[:question][:image])
    if @question.save
      flash[:success] = "質問が投稿できました。"
      redirect_to questions_path
    else
      render 'questions/new', status: :unprocessable_entity
    end
  end

  def edit
  end

  def destroy
    @question.destroy
    flash[:success] = "質問を削除しました"
    if request.referrer.nil?
      redirect_to questions_url, status: :see_other
    else
      redirect_to request.referrer, status: :see_other
    end
  end

  private

    def question_params
      params.require(:question).permit(:title, :content, :image)
    end

    def correct_user
      @question = current_user.questions.find_by(id: params[:id])
      redirect_to questions_url, status: :see_other if @question.nil?
    end
end
