# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Bookmarks API', type: :request do
  let(:user)    { create(:user, role: :member) }
  let(:article) { create(:article, status: :published) }

  describe 'GET /api/bookmarks' do
    it 'returns 401 without auth' do
      get '/api/bookmarks'
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns 200 with user's own bookmarks" do
      create(:bookmark, user: user, article: article)
      sign_in user
      get '/api/bookmarks'
      expect(response).to have_http_status(:ok)
      expect(json_data.length).to eq(1)
      expect(json_data.first['article']['id']).to eq(article.id)
    end
  end

  describe 'POST /api/bookmarks' do
    it 'returns 201 when creating a bookmark' do
      sign_in user
      post '/api/bookmarks', params: { article_id: article.id }, as: :json
      expect(response).to have_http_status(:created)
    end

    it 'returns 422 on duplicate bookmark' do
      create(:bookmark, user: user, article: article)
      sign_in user
      post '/api/bookmarks', params: { article_id: article.id }, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE /api/bookmarks/:id' do
    it 'returns 204 on success' do
      bookmark = create(:bookmark, user: user, article: article)
      sign_in user
      delete "/api/bookmarks/#{bookmark.id}"
      expect(response).to have_http_status(:no_content)
    end
  end

  def json
    JSON.parse(response.body)
  end

  def json_data
    json['data']
  end
end
