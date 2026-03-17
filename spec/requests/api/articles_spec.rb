# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Articles API', type: :request do
  let!(:published1) { create(:article, status: :published) }
  let!(:published2) { create(:article, status: :published) }
  let!(:draft)      { create(:article, status: :draft) }

  describe 'GET /api/articles' do
    it 'returns 200 with published articles' do
      get '/api/articles'
      expect(response).to have_http_status(:ok)
      ids = json_data.map { |a| a['id'] }
      expect(ids).to include(published1.id, published2.id)
      expect(ids).not_to include(draft.id)
    end

    it 'includes pagination meta' do
      get '/api/articles'
      meta = json['meta']
      expect(meta).to include('current_page', 'total_pages', 'total_count', 'per_page')
    end

    it 'supports ?page param' do
      get '/api/articles', params: { page: 1 }
      expect(response).to have_http_status(:ok)
    end

    it 'searches by q param' do
      special = create(:article, title: 'Уникальная биохимия статья', status: :published)
      get '/api/articles', params: { q: 'биохимия' }
      expect(response).to have_http_status(:ok)
      expect(json_data.map { |a| a['id'] }).to include(special.id)
    end

    it 'filters by section_id' do
      section = create(:section)
      in_section = create(:article, status: :published, section: section)
      get '/api/articles', params: { section_id: section.id }
      expect(response).to have_http_status(:ok)
      ids = json_data.map { |a| a['id'] }
      expect(ids).to include(in_section.id)
      expect(ids).not_to include(published1.id)
    end
  end

  describe 'GET /api/articles/:id' do
    it 'returns 200 with article data' do
      get "/api/articles/#{published1.id}"
      expect(response).to have_http_status(:ok)
      expect(json['data']['id']).to eq(published1.id)
    end

    it 'returns 404 for unknown id' do
      get '/api/articles/999999'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST /api/articles' do
    let(:editor) { create(:user, :editor) }
    let(:member) { create(:user, role: :member) }
    let(:article_params) { { article: { title: 'Новая статья', content: 'Содержимое статьи', status: 'published' } } }

    it 'returns 401 without auth' do
      post '/api/articles', params: article_params, as: :json
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns 403 for member' do
      sign_in member
      post '/api/articles', params: article_params, as: :json
      expect(response).to have_http_status(:forbidden)
    end

    it 'returns 201 for editor' do
      sign_in editor
      post '/api/articles', params: article_params, as: :json
      expect(response).to have_http_status(:created)
      expect(json['data']['title']).to eq('Новая статья')
    end

    it 'returns 422 with Russian error when title is blank' do
      sign_in editor
      post '/api/articles',
           params: { article: { title: '', content: 'Содержимое', status: 'published' } },
           as: :json
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json['errors']).to include('Заголовок не может быть пустым')
    end

    it 'returns 422 with Russian error when content is too short' do
      sign_in editor
      post '/api/articles',
           params: { article: { title: 'Заголовок', content: 'Мало', status: 'published' } },
           as: :json
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json['errors'].first).to match(/Содержимое слишком короткое \(минимум 10 символов\)/)
    end
  end

  describe 'PATCH /api/articles/:id' do
    let(:author)       { create(:user, :editor) }
    let(:other_editor) { create(:user, :editor) }
    let(:article)      { create(:article, author: author, status: :published) }

    it 'returns 403 for a different user' do
      sign_in other_editor
      patch "/api/articles/#{article.id}", params: { article: { title: 'Изменено' } }, as: :json
      expect(response).to have_http_status(:forbidden)
    end

    it 'returns 200 for the article author' do
      sign_in author
      patch "/api/articles/#{article.id}", params: { article: { title: 'Изменено' } }, as: :json
      expect(response).to have_http_status(:ok)
      expect(json['data']['title']).to eq('Изменено')
    end
  end

  describe 'DELETE /api/articles/:id' do
    let(:author)       { create(:user, :editor) }
    let(:other_editor) { create(:user, :editor) }
    let(:article)      { create(:article, author: author, status: :published) }

    it 'returns 403 for a different user' do
      sign_in other_editor
      delete "/api/articles/#{article.id}"
      expect(response).to have_http_status(:forbidden)
    end

    it 'returns 204 for the article author' do
      sign_in author
      delete "/api/articles/#{article.id}"
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
