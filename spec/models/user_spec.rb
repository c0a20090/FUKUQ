require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { User.new(name: 'Example User',
    email: 'user@example.com',
    password: 'foobar',
    password_confirmation: 'foobar') }

  it 'userが有効であること' do
    expect(user).to be_valid
  end

  it 'nameが存在すること' do
    user.name = '  '
    expect(user).to_not be_valid
  end

  it 'emailが存在すること' do
    user.email = '  '
    expect(user).to_not be_valid
  end

  it 'nameは3文字以上であること' do
    user.name = 'a' * 2
    expect(user).to_not be_valid
  end

  it 'nameは15文字以内であること' do
    user.name = 'a' * 16
    expect(user).to_not be_valid
  end

  it 'emailは255文字以内であること' do
    user.email = "#{'a' * 244}@example.com"
    expect(user).to_not be_valid
  end

  it 'emailが有効な形式であること' do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      user.email = valid_address
      expect(user).to be_valid
    end
  end

  it '無効な形式のemailは失敗すること' do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      user.email = invalid_address
      expect(user).to_not be_valid
    end
  end

  it 'emailは重複して登録できないこと' do
    duplicate_user = user.dup
    user.save
    expect(duplicate_user).to_not be_valid
  end

  it 'emailは小文字でDB登録されていること' do
    mixed_case_email = "Foo@ExAMPle.CoM"
    user.email = mixed_case_email
    user.save
    expect(user.reload.email).to eq mixed_case_email.downcase
  end

  it 'パスワードが存在すること' do
    user.password = user.password_confirmation = " " * 6
    expect(user).to_not be_valid
  end

  it 'パスワードは6文字以上であること' do
    user.password = user.password_confirmation = "a" * 5
    expect(user).to_not be_valid
  end

  it 'パスワードは32文字以内であること' do
    user.password = user.password_confirmation = "a" * 33
    expect(user).to_not be_valid
  end

  describe '#authenticated?' do
    it 'digestがnilならfalseを返すこと' do
      expect(user.authenticated?(:remember, '')).to be_falsy
    end
  end

  describe '#follow and #unfollow' do
    let(:user) { FactoryBot.create(:archer) }
    let(:other) { FactoryBot.create(:user) }
    let(:relationship) { Relationship.new(follower_id: user.id, 
                                          followed_id: other.id) }
    
    it 'relationshipが有効であること' do
      expect(relationship).to be_valid
    end

    it 'follower_idがないと無効になること' do
      relationship.follower_id = nil
      expect(relationship).to_not be_valid
    end

    it 'followed_idがないと無効になること' do
      relationship.followed_id = nil
      expect(relationship).to_not be_valid
    end
   
    it 'followするとfollowing?がtrueになること' do
      expect(user.following?(other)).to_not be_truthy
      user.follow(other)
      expect(user.following?(other)).to be_truthy
    end
   
    it 'unfollowするとfollowing?がfalseになること' do
      user.follow(other)
      expect(user.following?(other)).to_not be_falsey
      user.unfollow(other)
      expect(user.following?(other)).to be_falsey
    end

    it 'userは自分自身をフォローできないこと' do
      user.follow(user)
      expect(user.following?(user)).to_not be_truthy
    end

    it 'フォローされたらフォロワーに追加されること' do
      user.follow(other)
      expect(other.followers.include?(user)).to be_truthy
    end
  end

  describe '#feed' do
    let(:q_by_user) { FactoryBot.create(:q_by_user) }
    let(:q_by_guest) { FactoryBot.create(:q_by_guest) }
    let(:q_by_archer) { FactoryBot.create(:q_by_archer) }
    let(:user) { q_by_user.user }
    let(:guest) { q_by_guest.user }
    let(:archer) { q_by_archer.user }
   
    before do
      user.follow(guest)
    end
   
    it 'フォローしているユーザの投稿が表示されること' do
      guest.questions.each do |q_following|
        expect(user.feed.include?(q_following)).to be_truthy
      end
    end
   
    it '自分自身の投稿が表示されること' do
      user.questions.each do |q_self|
        expect(user.feed.include?(q_self)).to be_truthy
      end
    end
   
    it 'フォローしていないユーザの投稿は表示されないこと' do
      archer.questions.each do |q_unfollowed|
        expect(user.feed.include?(q_unfollowed)).to be_falsey
      end
    end
  end
end
