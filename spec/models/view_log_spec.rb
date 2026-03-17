# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ViewLog, type: :model do
  describe 'associations' do
    it { should belong_to(:user).optional }
    it { should belong_to(:article) }
  end
end
