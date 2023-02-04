FactoryBot.define do
  factory :answer, class: Answer do
    content { '回答です' }
    created_at { 10.minutes.ago }
    question { association :user }
  end

  factory :answer_recent, class: Answer do
    content { '最新の投稿です' }
    created_at { Time.zone.now }
    question { association :user }
  end
end

def user_with_answers(answers_count: 5)
  FactoryBot.create(:user) do |user|
    FactoryBot.create_list(:answer, answers_count, user: user)
  end
end
