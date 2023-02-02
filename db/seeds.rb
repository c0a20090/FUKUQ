# メインのサンプルユーザーを1人作成する
User.create!(name:  "masaya",
  email: "c0a200908d@edu.teu.ac.jp",
  password:              "1234567",
  password_confirmation: "1234567",
  admin:     true,
  activated: true,
  activated_at: Time.zone.now)

# 追加のユーザーをまとめて生成する
30.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@example.com"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

# ユーザーの一部を対象にマイクロポストを生成する
users = User.order(:created_at).take(6)
50.times do
  title = Faker::Lorem.sentence(word_count: 5)
  content = Faker::Lorem.sentence(word_count: 10)
  users.each { |user| user.questions.create!(title: title, content: content) }
end
