require 'rails_helper'
 
RSpec.describe "Questions", type: :request do

  describe '#create' do
    context '未ログインの場合' do
      it '登録されないこと' do
        expect {
          post questions_path, params: { question: { title: 'aiueo' , content: 'Lorem ipsum' } }
        }.to_not change(Question, :count)
      end
 
      it 'ログインページにリダイレクトされること' do
        post questions_path, params: { question: { title: 'aiueo' , content: 'Lorem ipsum' } }
        expect(response).to redirect_to login_path
      end
    end
  end
 
  describe '#destroy' do
    let(:question) { FactoryBot.create(:question) }
 
    before do
      @post = FactoryBot.create(:most_recent)
    end
 
    context '未ログインの場合' do
      it '削除されないこと' do
        expect {
          delete question_path(@post)
        }.to_not change(Question, :count)
      end
 
      it 'ログインページにリダイレクトされること' do
        delete question_path(@post)
        expect(response).to redirect_to login_path
      end
    end
  end
end