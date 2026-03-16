require "rails_helper"

RSpec.describe ArticlePolicy, type: :policy do
  let(:guest)   { build(:user, role: :guest) }
  let(:member)  { build(:user, role: :member) }
  let(:editor)  { build(:user, :editor) }
  let(:admin)   { build(:user, :admin) }

  let(:author)  { create(:user, :editor) }
  let(:article) { create(:article, author: author, status: :published) }
  let(:draft)   { create(:article, author: author, status: :draft) }

  describe "create?" do
    it "denies guest" do
      expect(described_class.new(guest, Article.new)).not_to be_create
    end

    it "denies member" do
      expect(described_class.new(member, Article.new)).not_to be_create
    end

    it "permits editor" do
      expect(described_class.new(editor, Article.new)).to be_create
    end

    it "permits admin" do
      expect(described_class.new(admin, Article.new)).to be_create
    end
  end

  describe "update?" do
    it "denies another editor" do
      other_editor = build(:user, :editor)
      expect(described_class.new(other_editor, article)).not_to be_update
    end

    it "permits the article author" do
      expect(described_class.new(author, article)).to be_update
    end

    it "permits admin regardless of authorship" do
      expect(described_class.new(admin, article)).to be_update
    end
  end

  describe "destroy?" do
    it "denies another editor" do
      other_editor = build(:user, :editor)
      expect(described_class.new(other_editor, article)).not_to be_destroy
    end

    it "permits the article author" do
      expect(described_class.new(author, article)).to be_destroy
    end

    it "permits admin" do
      expect(described_class.new(admin, article)).to be_destroy
    end
  end

  describe "Scope#resolve" do
    before do
      article
      draft
    end

    it "returns only published articles for non-admin" do
      scope = ArticlePolicy::Scope.new(member, Article.all).resolve
      expect(scope).to include(article)
      expect(scope).not_to include(draft)
    end

    it "returns all articles (draft + published) for admin" do
      scope = ArticlePolicy::Scope.new(admin, Article.all).resolve
      expect(scope).to include(article, draft)
    end

    it "returns only published articles for nil user" do
      scope = ArticlePolicy::Scope.new(nil, Article.all).resolve
      expect(scope).to include(article)
      expect(scope).not_to include(draft)
    end
  end
end
