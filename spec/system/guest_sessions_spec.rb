require 'rails_helper'
 
RSpec.describe "GuestSessions", type: :system do
  before do
    driven_by(:rack_test)
  end
 
  describe '#new' do
    let(:guest_user) { FactoryBot.create(:guest_user) }

    it 'ゲストログインだと設定が表示されないこと' do
      visit login_path
    
      fill_in 'メールアドレス', with: guest_user.email
      fill_in 'パスワード', with: guest_user.password
      click_button 'ログイン'
    
      expect(page).to_not have_selector "a[href=\"#{edit_user_path(guest_user)}\"]"
    end
  end
end