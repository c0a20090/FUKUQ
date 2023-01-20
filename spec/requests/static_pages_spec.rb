require 'rails_helper'
 
RSpec.describe 'StaticPages', type: :request do
  let(:base_title) { 'FUKUQ' }
  describe '#home' do
    it '正常にレスポンスを返すこと' do
      get root_path
      expect(response).to have_http_status :ok
    end

    it 'titleがFUKUQであること' do
      get root_path
      expect(response.body).to include "<title>#{base_title}</title>"
    end
  end

  describe '#help' do
    it '正常にレスポンスを返すこと' do
      get help_path
      expect(response).to have_http_status :ok
    end

    it 'ヘルプ | FUKUQが含まれること' do
      get help_path
      expect(response.body).to include "ヘルプ | #{base_title}"
    end
  end

  describe '#about' do
    it '正常にレスポンスを返すこと' do
      get about_path
      expect(response).to have_http_status :ok
    end

    it '概要 | FUKUQが含まれること' do
      get about_path
      expect(response.body).to include "概要 | #{base_title}"
    end
  end

  describe '#contact' do
    it '正常にレスポンスを返すこと' do
      get contact_path
      expect(response).to have_http_status :ok
    end

    it 'お問い合わせ | FUKUQが含まれること' do
      get contact_path
      expect(response.body).to include "お問い合わせ | #{base_title}"
    end
  end
end
