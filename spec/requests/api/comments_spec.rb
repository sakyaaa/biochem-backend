# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Comments API', type: :request do
  let(:article)           { create(:article, status: :published) }
  let!(:approved_comment) { create(:comment, article: article, approved: true) }
  let!(:pending_comment)  { create(:comment, article: article, approved: false) }

  describe 'GET /api/articles/:article_id/comments' do
    it 'returns 200 with only approved comments' do
      get "/api/articles/#{article.id}/comments"
      expect(response).to have_http_status(:ok)
      ids = json_data.map { |c| c['id'] }
      expect(ids).to include(approved_comment.id)
      expect(ids).not_to include(pending_comment.id)
    end
  end

  describe 'POST /api/articles/:article_id/comments' do
    let(:member) { create(:user, role: :member) }

    it 'returns 401 without auth' do
      post "/api/articles/#{article.id}/comments",
           params: { comment: { body: 'Отличная статья!' } }, as: :json
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns 201 with auth and new comment is pending by default' do
      sign_in member
      post "/api/articles/#{article.id}/comments",
           params: { comment: { body: 'Отличная статья!' } }, as: :json
      expect(response).to have_http_status(:created)
      expect(json['data']['approved']).to be false
    end

    it 'returns 422 with Russian error when body is too short' do
      sign_in member
      post "/api/articles/#{article.id}/comments",
           params: { comment: { body: 'ок' } }, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json['errors'].first).to match(/Комментарий слишком короткий/)
    end

    it 'returns 422 with Russian error when body is blank' do
      sign_in member
      post "/api/articles/#{article.id}/comments",
           params: { comment: { body: '' } }, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json['errors']).to include('Текст комментария не может быть пустым')
    end
  end

  def json
    JSON.parse(response.body)
  end

  def json_data
    json['data']
  end
end
