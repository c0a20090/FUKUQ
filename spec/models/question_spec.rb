require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:question) { user.questions.build(title: '朝ごはんメニュー', content: '作り置きできるなにかいいメニューはないか') }

  it '有効であること' do
    expect(question).to be_valid
  end
 
  it 'user_idがない場合は無効であること' do
    question.user_id = nil
    expect(question).to_not be_valid
  end

  it '並び順は投稿の新しい順になっていること' do
    FactoryBot.send(:user_with_questions)
    expect(FactoryBot.create(:most_recent)).to eq Question.first
  end

  it '投稿したユーザが削除された場合、そのユーザのQuestionも削除されること' do
    post = FactoryBot.create(:most_recent)
    user = post.user
    expect {
      user.destroy
    }.to change(Question, :count).by -1
  end

  describe 'title' do
    it '空なら無効であること' do
      question.title = " "
      expect(question).to_not be_valid
    end

    it 'titleが26文字以上なら無効であること' do
      question.title = "a" * 26
      expect(question).to_not be_valid
    end
  end

  describe 'content' do
    it '空なら無効であること' do
      question.content = " "
      expect(question).to_not be_valid
    end

    it 'contentが1001文字以上なら無効であること' do
      question.content = "a" * 1001
      expect(question).to_not be_valid
    end
  end
end
