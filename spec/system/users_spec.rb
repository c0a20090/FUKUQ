require 'rails_helper'

RSpec.describe "Users", type: :system do
  before do
    driven_by(:rack_test)
  end
  
  describe '#create' do
    context '無効な値の場合' do
      it 'エラーメッセージ用の表示領域が描画されていること' do
        visit signup_path
        fill_in 'ユーザーネーム', with: ''
        fill_in 'メールアドレス', with: 'user@invlid'
        fill_in 'パスワード', with: 'foo'
        fill_in 'パスワード確認', with: 'bar'
        click_button '登録する'
  
        expect(page).to have_selector 'div#error_explanation'
        expect(page).to have_selector 'div.field_with_errors'
      end
    end
  end

  describe '#index' do
    let!(:admin) { FactoryBot.create(:archer) }
    let!(:not_admin) { FactoryBot.create(:user) }
   
    it 'adminユーザならdeleteリンクが表示されること' do
      log_in admin
      visit users_path
      expect(page).to have_link '削除する'
    end
   
    it 'adminユーザでなければdeleteリンクが表示されないこと' do
      log_in not_admin
      visit users_path
  
      expect(page).to_not have_link 'delete'
    end
  end

  describe 'show' do
    it 'フォローとフォロワーが表示されること' do
    user = FactoryBot.send(:create_relationships)
    log_in user
    #  expect(page).to have_content '10 フォロー'
    #  expect(page).to have_content '10 フォロワー'

    visit user_path(user)
    expect(page).to have_content '10 フォロー'
    expect(page).to have_content '10 フォロワー'
    end
  end
 end