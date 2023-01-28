require 'rails_helper'
 
RSpec.describe "StaticPages", type: :system do
  before do
    driven_by(:rack_test)
  end
 
  describe 'root' do
    it 'root、aboutへのリンクが表示されていること' do
      visit root_path
      link_to_root = page.find_all("a[href=\"#{root_path}\"]")
 
      expect(link_to_root.size).to eq 1
      # expect(page).to have_link 'ヘルプ', href: help_path
      expect(page).to have_link 'FUKUQとは', href: about_path
      # expect(page).to have_link 'お問い合わせ', href: contact_path
      expect(page).to have_link '新規登録', href: signup_path
    end
  end
end