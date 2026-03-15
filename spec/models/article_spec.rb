require "rails_helper"

RSpec.describe Article, type: :model do
  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:content) }
    it { should belong_to(:author).class_name("User") }
    it { should belong_to(:section).optional }
    it { should have_many(:comments).dependent(:destroy) }
  end

  describe "scopes" do
    let!(:published) { create(:article, status: :published) }
    let!(:draft)     { create(:article, status: :draft) }

    it "returns only published articles" do
      expect(Article.published).to include(published)
      expect(Article.published).not_to include(draft)
    end
  end
end
