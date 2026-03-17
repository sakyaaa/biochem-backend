# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Article, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:content) }
    it { should belong_to(:author).class_name('User') }
    it { should belong_to(:section).optional }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_and_belong_to_many(:tags) }
  end

  describe 'scopes' do
    let!(:published) { create(:article, status: :published) }
    let!(:draft)     { create(:article, status: :draft) }
    let!(:section)   { create(:section) }
    let!(:in_section) { create(:article, status: :published, section: section) }

    describe '.published' do
      it 'returns only published articles' do
        expect(Article.published).to include(published, in_section)
        expect(Article.published).not_to include(draft)
      end
    end

    describe '.by_section' do
      it 'filters articles by section_id' do
        expect(Article.by_section(section.id)).to include(in_section)
        expect(Article.by_section(section.id)).not_to include(published)
      end
    end

    describe '.popular' do
      before do
        Article.where(id: published.id).update_all(views_count: 100)
        Article.where(id: in_section.id).update_all(views_count: 50)
      end

      it 'does not include draft articles' do
        expect(Article.popular).not_to include(draft)
      end

      it 'orders published articles by views_count desc' do
        popular_ids = Article.popular.map(&:id)
        expect(popular_ids.index(published.id)).to be < popular_ids.index(in_section.id)
      end
    end
  end

  describe '.search_fulltext' do
    let!(:article) { create(:article, title: 'Биомеханика суставов', status: :published) }

    it 'returns articles matching the search query' do
      results = Article.search_fulltext('Биомеханика')
      expect(results).to include(article)
    end
  end
end
