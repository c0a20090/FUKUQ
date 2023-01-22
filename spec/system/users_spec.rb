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
 end