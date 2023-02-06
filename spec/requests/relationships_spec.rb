require 'rails_helper'
 
RSpec.describe 'Relationships', type: :request do

  context '未ログインの場合' do
    it 'ログインページにリダイレクトすること' do
      post relationships_path
      expect(response).to redirect_to login_path
    end

    it '登録されないこと' do
      expect {
        post relationships_path
      }.to_not change(Relationship, :count)
    end
  end

  describe '#create' do
    let(:user) { FactoryBot.create(:user) }
    let(:other) { FactoryBot.create(:archer) }
    before do
      log_in user
    end

    it '普通にフォローした場合' do
      expect {
        post relationships_path, params: { followed_id: other.id }
      }.to change(Relationship, :count).by 1
      expect(response).to redirect_to other
    end
     
    it 'Hotwireでフォローした場合' do
      expect {
        post relationships_path(format: :turbo_stream), 
             params: { followed_id: other.id }
      }.to change(Relationship, :count).by 1
    end
  end

  describe '#destroy' do
    let(:user) { FactoryBot.create(:user) }
    let(:other) { FactoryBot.create(:archer) }
    let(:relationship) { user.active_relationships.find_by(followed_id: other.id) }

    before do
      user.follow(other)
      log_in user
    end

    it '普通に削除した場合' do
      expect {
        delete relationship_path(relationship)
      }.to change(Relationship, :count).by -1
      expect(response).to have_http_status(:see_other)
      expect(response).to redirect_to other
    end
   
    it 'Hotwireで削除した場合' do
      expect {
        delete relationship_path(relationship, format: :turbo_stream)
      }.to change(Relationship, :count).by -1
    end
  end
end
