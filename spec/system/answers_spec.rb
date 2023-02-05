# require 'rails_helper'

# RSpec.describe "Answers", type: :system do
#   before do
#     driven_by(:rack_test)
#   end

#   describe 'Answers#create' do
#     before do
#       FactoryBot.send(:question_with_answers, answers_count: 35)
#       @user = Answer.first.user
#       @question = Answer.first.question
#       log_in @user
#       visit questions_path
#       visit question_path(@question)
#     end

#     it '回答できること' do
#       expect {
#         fill_in 'answer_content', with: '回答です'
#         click_button '回答する'
#       }.to change(Answer, :count).by 1
#     end
#   end
# end