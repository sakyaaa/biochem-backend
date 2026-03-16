require "rails_helper"

RSpec.describe CommentPolicy, type: :policy do
  let(:guest)        { build(:user, role: :guest) }
  let(:member)       { create(:user, role: :member) }
  let(:admin)        { build(:user, :admin) }
  let(:comment_owner) { create(:user, role: :member) }
  let(:comment)      { create(:comment, user: comment_owner) }

  describe "create?" do
    it "denies unauthenticated user (nil)" do
      expect(described_class.new(nil, Comment.new)).not_to be_create
    end

    it "permits any authenticated user regardless of role" do
      expect(described_class.new(guest, Comment.new)).to be_create
      expect(described_class.new(member, Comment.new)).to be_create
    end
  end

  describe "destroy?" do
    it "permits the comment owner" do
      expect(described_class.new(comment_owner, comment)).to be_destroy
    end

    it "permits admin" do
      expect(described_class.new(admin, comment)).to be_destroy
    end

    it "denies other users" do
      other_user = build(:user, role: :member)
      expect(described_class.new(other_user, comment)).not_to be_destroy
    end
  end
end
