require "rails_helper"

RSpec.describe Comment, type: :model do
  describe "validations" do
    it { should validate_presence_of(:body) }
    it { should validate_length_of(:body).is_at_least(5).is_at_most(2000) }
  end

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:article) }
  end

  describe "scopes" do
    let!(:approved_comment) { create(:comment, approved: true) }
    let!(:pending_comment)  { create(:comment, :pending) }

    describe ".approved" do
      it "returns only approved comments" do
        expect(Comment.approved).to include(approved_comment)
        expect(Comment.approved).not_to include(pending_comment)
      end
    end

    describe ".pending" do
      it "returns only pending comments" do
        expect(Comment.pending).to include(pending_comment)
        expect(Comment.pending).not_to include(approved_comment)
      end
    end
  end
end
