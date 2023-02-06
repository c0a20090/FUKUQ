require 'rails_helper'
 
RSpec.describe "Users", type: :request do
  describe "GET /signup" do
    it "returns http success" do
      get signup_path
      expect(response).to have_http_status(:ok)
    end

    it '新規登録 | FUKUQが含まれること' do
      get signup_path
      expect(response.body).to include full_title('新規登録')
    end
  end

  describe 'POST /users #create' do
    it '無効な値だと登録されないこと' do
      expect {
        post users_path, params: { user: { name: '',
                                           email: 'user@invlid',
                                           password: 'foo',
                                           password_confirmation: 'bar' } }
      }.to_not change(User, :count)
    end

    context '有効な値の場合' do
      let(:user_params) { { user: { name: 'Example User',
                                    email: 'user@example.com',
                                    password: 'password',
                                    password_confirmation: 'password' } } }
      
      before do
       ActionMailer::Base.deliveries.clear
      end
  
      it '登録されること' do
        expect {
          post users_path, params: user_params
        }.to change(User, :count).by 1
      end

      it 'flashが表示されること' do
        post users_path, params: user_params
        expect(flash).to be_any
      end

      it 'メールが1件存在すること' do
        post users_path, params: user_params
        expect(ActionMailer::Base.deliveries.size).to eq 1
      end
 
      it '登録時点では有効化されていないこと' do
        post users_path, params: user_params
        expect(User.last).to_not be_activated
      end
    end
  end

  describe 'get /users/{id}/edit' do
    let(:user) { FactoryBot.create(:user) }
   
    it 'タイトルがユーザー編集 | FUKUQであること' do
      log_in user
      get edit_user_path(user)
      expect(response.body).to include full_title('ユーザー編集')
    end
   
    context '未ログインの場合' do
      it 'flashが空でないこと' do
        get edit_user_path(user)
        expect(flash).to_not be_empty
      end
   
      it '未ログインユーザはログインページにリダイレクトされること' do
        get edit_user_path(user)
        expect(response).to redirect_to login_path
      end

      it 'ログインすると編集ページにリダイレクトされること(フレンドリーフォワーディング)' do
        get edit_user_path(user)
        log_in user
        expect(response).to redirect_to edit_user_path(user)
      end
    end

    context '別のユーザの場合' do
      let(:other_user) { FactoryBot.create(:archer) }
     
      it 'flashが空であること' do
        log_in user
        get edit_user_path(other_user)
        expect(flash).to be_empty
      end
     
      it 'root_pathにリダイレクトされること' do
        log_in user
        get edit_user_path(other_user)
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'PATCH /users' do
    let(:user) { FactoryBot.create(:user) }
    let(:admin_user) { FactoryBot.create(:archer) }

    it 'タイトルがユーザー編集 | FUKUQであること' do
      log_in user
      get edit_user_path(user)
      expect(response.body).to include full_title('ユーザー編集')
    end

    it '管理者にはアカウント削除ボタンがないこと' do
      log_in admin_user
      get edit_user_path(admin_user)
      expect(response.body).to_not include 'アカウントを削除する'
    end
 
    context '無効な値の場合' do
      before do
        log_in user
        patch user_path(user), params: { user: { name: '',
                                                 email: 'foo@invlid',
                                                 password: 'foo',
                                                 password_confirmation: 'bar' } }
      end

      it '更新できないこと' do
        user.reload
        expect(user.name).to_not eq ''
        expect(user.email).to_not eq ''
        expect(user.password).to_not eq 'foo'
        expect(user.password_confirmation).to_not eq 'bar'
      end
 
      it '更新アクション後にeditのページが表示されていること' do
        expect(response.body).to include full_title('ユーザー編集')
      end

      it '5個のエラーがありますと表示されていること' do
        expect(response.body).to include '5個のエラーがあります'
      end
    end

    context '未ログインの場合' do
      it 'flashが空でないこと' do
        patch user_path(user), params: { user: { name: user.name,
                                                  email: user.email } }
        expect(flash).to_not be_empty
      end
    
      it '未ログインユーザはログインページにリダイレクトされること' do
        patch user_path(user), params: { user: { name: user.name,
                                            email: user.email } }
        expect(response).to redirect_to login_path
      end
    end

    context '有効な値の場合' do
      before do
        log_in user
        @name = 'Foo Bar'
        @email = 'foo@bar.com'
        patch user_path(user), params: { user: { name: @name,
                                                 email: @email,
                                                 password: '',
                                                 password_confirmation: '' } }
      end
    
      it '更新できること' do
        user.reload
        expect(user.name).to eq @name
        expect(user.email).to eq @email
      end
   
      it 'Users#showにリダイレクトすること' do
        expect(response).to redirect_to user
      end
   
      it 'flashが表示されていること' do
        expect(flash).to be_any
      end
    end
  end
  
  describe 'GET /users' do
    let(:user) { FactoryBot.create(:user) }
    let(:admin_user) {FactoryBot.create(:archer)}

    it 'ログインしていなければログインページにリダイレクトすること' do
      get users_path
      expect(response).to redirect_to login_path
    end

    it 'ログインしていないかつ管理者以外だったらルートページにリダイレクトすること' do
      log_in user
      get users_path
      expect(response).to redirect_to root_path
    end

    describe 'pagination' do
      before do
        30.times do
          FactoryBot.create(:continuous_users)
        end
        log_in admin_user
        get users_path
      end
     
      it 'ul.paginationが存在すること' do
        expect(response.body).to include '<ul class="pagination ">'
      end
    
      it 'ユーザごとのリンクが存在すること' do
        User.page(1).each do |user|
          expect(response.body).to include "<a href=\"#{user_path(user)}\">"
        end
      end
    end

    describe 'DELETE /users/{id}' do
      let!(:admin_user) {FactoryBot.create(:archer)}
      let!(:other_user) {FactoryBot.create(:user) }
     
      context '未ログインの場合' do
        it '削除できないこと' do
          expect {
            delete user_path(admin_user)
          }.to_not change(User, :count)
        end
     
        it 'ログインページにリダイレクトすること' do
          delete user_path(admin_user)
          expect(response).to redirect_to login_path
        end
      end
     
      context 'adminユーザでログインしている場合' do
        it '他のユーザーを削除できることの確認' do
          log_in admin_user
          expect {
            delete user_path(other_user)
          }.to change(User, :count).by -1
        end
      end
    end
  end

  describe 'GET /users/{id}/following' do
    let(:user) { FactoryBot.create(:user) }
 
    it '未ログインならログインページにリダイレクトすること' do
      get following_user_path(user)
      expect(response).to redirect_to login_path
    end
  end
 
  describe 'GET /users/{id}/followers' do
    let(:user) { FactoryBot.create(:user) }
 
    it '未ログインならログインページにリダイレクトすること' do
      get followers_user_path(user)
      expect(response).to redirect_to login_path
    end
  end
end