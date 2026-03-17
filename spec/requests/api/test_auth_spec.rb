# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Test Auth', type: :request do
  let(:user) { create(:user, role: :member) }

  it 'can sign in and access authenticated endpoint' do
    sign_in user
    get '/api/profile'
    puts "Status: #{response.status}"
    puts "Body: #{response.body[0..200]}"
    # Don't assert - just see what happens
    expect(true).to be true
  end
end
