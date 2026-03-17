# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Auth::Registrations API', type: :request do
  describe 'POST /api/auth/sign_up' do
    let(:valid_params) do
      {
        api_user: {
          name: 'Тестовый Пользователь',
          email: "test_#{SecureRandom.hex(4)}@example.com",
          password: 'Password123!',
          password_confirmation: 'Password123!'
        }
      }
    end

    it 'returns 201 with valid data' do
      post '/api/auth/sign_up', params: valid_params, as: :json
      expect(response).to have_http_status(:created)
      expect(json['data']['email']).to eq(valid_params[:api_user][:email])
      expect(json['message']).to be_present
    end

    it 'returns 422 with duplicate email and Russian error' do
      existing = create(:user)
      post '/api/auth/sign_up',
           params: { api_user: {
             name: 'Другой',
             email: existing.email,
             password: 'Password123!',
             password_confirmation: 'Password123!'
           } }, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json['errors']).to include('Этот email уже зарегистрирован')
    end

    it 'returns 422 when name is missing with Russian error' do
      params = { api_user: valid_params[:api_user].except(:name) }
      post '/api/auth/sign_up', params: params, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json['errors']).to include('Имя не может быть пустым')
    end

    it 'returns 422 when password is too short with Russian error' do
      params = valid_params.deep_merge(api_user: { password: '123', password_confirmation: '123' })
      post '/api/auth/sign_up', params: params, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json['errors'].first).to match(/Пароль слишком короткий/)
    end
  end

  def json
    JSON.parse(response.body)
  end
end
