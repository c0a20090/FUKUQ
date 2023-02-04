FactoryBot.define do
  factory :orange, class: Question do
    title { 'みかん' }
    content { 'おすすめのみかんを教えて' }
    created_at { 10.minutes.ago }
  end
 
  factory :most_recent, class: Question do
    title { '問題解けない' }
    content { '3番の解き方教えて' }
    created_at { Time.zone.now }
    user { association :user, email: 'recent@example.com' }
  end

  factory :question, class: Question do
    title {' タイトルです '}
    content { '内容です' }
    user { association :user }
  end
end
 
def user_with_questions(questions_count: 5)
  FactoryBot.create(:user) do |user|
    FactoryBot.create_list(:orange, questions_count, user: user)
  end
end
