# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tags API', type: :request do
  describe 'GET /api/tags' do
    let!(:tag)     { create(:tag) }
    let!(:article) { create(:article, status: :published, tag_ids: [tag.id]) }

    it 'returns 200 with tags that have published articles' do
      get '/api/tags'
      expect(response).to have_http_status(:ok)
      ids = json_data.map { |t| t['id'] }
      expect(ids).to include(tag.id)
    end

    it 'includes articles_count field' do
      get '/api/tags'
      tag_data = json_data.find { |t| t['id'] == tag.id }
      expect(tag_data['articles_count']).to eq(1)
    end

    it 'returns tags with no published articles (articles_count = 0)' do
      orphan_tag = create(:tag)
      get '/api/tags'
      ids = json_data.map { |t| t['id'] }
      expect(ids).to include(orphan_tag.id)
      orphan_data = json_data.find { |t| t['id'] == orphan_tag.id }
      expect(orphan_data['articles_count']).to eq(0)
    end
  end

  def json
    JSON.parse(response.body)
  end

  def json_data
    json['data']
  end
end
