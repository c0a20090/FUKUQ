require 'rails_helper'
 
RSpec.describe "StaticPages", type: :system do
  before do
    driven_by(:rack_test)
  end
 
  describe 'root' do
    it 'rootへのリンクが表示されていること' do
      visit root_path
      link_to_root = page.find_all("a[href=\"#{root_path}\"]")
 
      expect(link_to_root.size).to eq 1
      expect(page).to have_link '質問する', href: new_question_path
      expect(page).to have_link 'ログイン', href: login_path
      expect(page).to have_link '新規登録', href: signup_path
    end
  end
end