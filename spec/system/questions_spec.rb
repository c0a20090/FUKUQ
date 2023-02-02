require 'rails_helper'
 
RSpec.describe "Questions", type: :system do
  before do
    driven_by(:rack_test)
  end
 
  describe 'Users#show' do
    before do
      FactoryBot.send(:user_with_questions, questions_count: 35)
      @user = Question.first.user
    end
 
    it '20件表示されていること' do
      visit user_path @user
 
      questions_wrapper =
        within 'ol.questions' do
          find_all('li')
        end
      expect(questions_wrapper.size).to eq 20
    end
 
    it 'ページネーションのラッパータグが表示されていること' do
      visit user_path @user
      expect(page).to have_selector '.pagination'
    end
 
    it 'Questionのタイトルがページ内に表示されていること' do
      visit user_path @user
      @user.questions.page(1).each do |question|
        expect(page).to have_content question.title
      end
    end
  end

  describe 'Questions#show' do
    before do
      FactoryBot.send(:user_with_questions, questions_count: 35)
      @user = Question.first.user
      @user.password = 'password'
      log_in @user
      visit new_question_path
    end

    it '画像添付ができること' do
      expect {
        fill_in 'question_title', with: 'This question is true'
        fill_in 'question_content', with: 'This question really ties the room together'
        attach_file 'question[image]', "#{Rails.root}/spec/factories/kitten.jpg"
        click_button '投稿する'
      }.to change(Question, :count).by 1
     
      attached_question = Question.first
      visit question_path(attached_question)
      expect(attached_question.image).to be_attached
    end
  end

  describe 'Questions#new' do
    before do
      FactoryBot.send(:user_with_questions, questions_count: 35)
      @user = Question.first.user
      @user.password = 'password'
      log_in @user
      visit new_question_path
    end

    context '有効な送信の場合' do
      it '投稿されること' do
        expect {
          fill_in 'question_title', with: 'This question is true'
          fill_in 'question_content', with: 'This question really ties the room together'
          click_button '投稿する'
        }.to change(Question, :count).by 1
      end
    end
   
    context '無効な送信の場合' do
      it 'contentが空なら投稿されないこと' do
        fill_in 'question_title', with: ''
        fill_in 'question_content', with: ''
        click_button '投稿する'
  
        expect(page).to have_selector 'div#error_explanation'
      end
    end
  end

  describe 'Questions#index' do
    before do
      FactoryBot.send(:user_with_questions, questions_count: 35)
      @user = Question.first.user
      @user.password = 'password'
      log_in @user
    end

    it 'ページネーションのラッパータグがあること' do
      visit questions_path
      expect(page).to have_selector '.pagination'
    end

    context '有効な送信の場合' do

      it '投稿されること' do
        visit new_question_path
        fill_in 'question_title', with: 'This question is true'
        fill_in 'question_content', with: 'This question really ties the room together'
        click_button '投稿する'
        redirect_to questions_path
        expect(page).to have_content 'This question is true'
      end
    end
  end

  describe 'Question#@user' do
    before do
      FactoryBot.send(:user_with_questions, questions_count: 35)
      @user = Question.first.user
      @user.password = 'password'
      log_in @user
    end

    it '質問数：35件と表示されること' do
      visit user_path(@user)
      expect(page).to have_content '質問数：35件'
    end

    it 'deleteボタンが表示されていること' do
      visit new_question_path
      fill_in 'question_title', with: 'This question is true'
      fill_in 'question_content', with: 'This question really ties the room together'
      click_button '投稿する'
      
      question = Question.first

      visit user_path(@user)
      expect {
        click_link '削除する', href: question_path(question)
      }.to change(Question, :count).by -1
      expect(page).to_not have_content 'This question is true'
    end

    it '他のユーザのプロフィールではdeleteボタンが表示されないこと' do
      @other_user = FactoryBot.create(:archer)
      visit user_path(@other_user)
      expect(page).to_not have_link '削除する'
    end
  end
end