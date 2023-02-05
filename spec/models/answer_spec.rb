require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:answer) { FactoryBot.create(:answer) }

  it '有効であること' do
    expect(answer).to be_valid
  end

  it 'user_idがないと無効になる' do
    answer.user_id = nil
    expect(answer).to_not be_valid
  end

  it 'question_idがないと無効になる' do
    answer.question_id = nil
    expect(answer).to_not be_valid
  end

  it '並び順は投稿の新しい順になっている' do
    FactoryBot.send(:question_with_answers)
    expect(FactoryBot.create(:answer_recent)).to eq Answer.last
  end

  it '質問が削除されたらその回答も削除される' do
    answer = FactoryBot.create(:answer)
    question = answer.question
    expect {
      question.destroy
    }.to change(Answer, :count).by -1
  end

  describe 'content' do
    it '空なら無効になる' do
      answer.content = '  '
      expect(answer).to_not be_valid
    end

    it '1000字以上だと無効になる' do
      answer.content = 'a' * 1001
      expect(answer).to_not be_valid
    end
  end
end
