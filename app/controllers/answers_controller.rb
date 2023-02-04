class AnswersController < ApplicationController
  before_action :logged_in_user

  def create
    @answer = Answer.new(answer_params)
    @answer.user_id = current_user.id
    @answer.question_id = params[:question_id]
    if @answer.save
      flash[:success] = "回答しました"
      redirect_to "/questions/#{params[:question_id]}"
    else
      @question = Question.find(params[:question_id])
      render "questions/show", status: :unprocessable_entity
    end
  end

  private
    def answer_params
      params.require(:answer).permit(:content)
    end
end
