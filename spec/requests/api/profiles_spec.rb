# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Profile API', type: :request do
  let(:user) { create(:user, role: :member) }

  describe 'GET /api/profile' do
    it 'returns 401 without auth' do
      get '/api/profile'
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns 200 with profile data' do
      sign_in user
      get '/api/profile'
      expect(response).to have_http_status(:ok)
      data = json['data']
      expect(data['id']).to eq(user.id)
      expect(data['email']).to eq(user.email)
      expect(data.keys).to include('name', 'role', 'created_at')
    end
  end

  describe 'PATCH /api/profile' do
    it 'returns 200 and updates the name' do
      sign_in user
      patch '/api/profile',
            params: { user: { name: 'Новое Имя' } },
            as: :json
      expect(response).to have_http_status(:ok)
      expect(json['data']['name']).to eq('Новое Имя')
    end

    it 'returns 422 with Russian error when name is blank' do
      sign_in user
      patch '/api/profile',
            params: { user: { name: '' } },
            as: :json
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json['errors']).to include('Имя не может быть пустым')
    end
  end

  def json
    JSON.parse(response.body)
  end
end
