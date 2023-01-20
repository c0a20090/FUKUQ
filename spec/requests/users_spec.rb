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
end
