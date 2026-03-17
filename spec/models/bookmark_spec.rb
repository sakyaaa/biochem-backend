# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:article) }
  end

  describe 'validations' do
    it 'prevents duplicate bookmark for same user and article' do
      bookmark = create(:bookmark)
      duplicate = build(:bookmark, user: bookmark.user, article: bookmark.article)
      expect(duplicate).not_to be_valid
    end
  end
end
