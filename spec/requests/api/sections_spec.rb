# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sections API', type: :request do
  let!(:section1) { create(:section) }
  let!(:section2) { create(:section) }

  describe 'GET /api/sections' do
    it 'returns 200 with all sections' do
      get '/api/sections'
      expect(response).to have_http_status(:ok)
      ids = json_data.map { |s| s['id'] }
      expect(ids).to include(section1.id, section2.id)
    end

    it 'includes expected fields' do
      get '/api/sections'
      first = json_data.first
      expect(first.keys).to include('id', 'name', 'slug', 'articles_count')
    end
  end

  describe 'GET /api/sections/:id (by slug)' do
    it 'returns 200 for an existing slug' do
      get "/api/sections/#{section1.slug}"
      expect(response).to have_http_status(:ok)
      expect(json['data']['slug']).to eq(section1.slug)
    end

    it 'returns 404 for unknown slug' do
      get '/api/sections/nonexistent-slug'
      expect(response).to have_http_status(:not_found)
    end
  end

  def json
    JSON.parse(response.body)
  end

  def json_data
    json['data']
  end
end
