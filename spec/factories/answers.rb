FactoryBot.define do
  factory :answer, class: Answer do
    content { '回答です' }
    created_at { 10.minutes.ago }
    question { association :question }
    user { question.user }
  end

  factory :answer_recent, class: Answer do
    content { '最新の投稿です' }
    created_at { Time.zone.now }
    question { association :most_recent }
    user { question.user }
  end
end

def question_with_answers(answers_count: 5)
  FactoryBot.create(:question) do |question|
    FactoryBot.create_list(:answer, answers_count, question: question)
  end
end
