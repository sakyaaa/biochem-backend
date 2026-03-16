require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(100) }
    # email validated by Devise :validatable
    it { should validate_presence_of(:email) }
  end

  describe "associations" do
    it { should have_many(:articles).with_foreign_key("author_id") }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:bookmarks).dependent(:destroy) }
    it { should have_many(:view_logs).dependent(:nullify) }
  end

  describe "role enum" do
    it "defines guest, member, editor, admin roles" do
      expect(User.roles.keys).to eq(%w[guest member editor admin])
    end

    it "defaults to guest" do
      user = build(:user)
      user.role = :guest
      expect(user.guest?).to be true
    end
  end

  describe "#editor_or_admin?" do
    it "returns true for editor" do
      expect(build(:user, :editor).editor_or_admin?).to be true
    end

    it "returns true for admin" do
      expect(build(:user, :admin).editor_or_admin?).to be true
    end

    it "returns false for member" do
      expect(build(:user, role: :member).editor_or_admin?).to be false
    end

    it "returns false for guest" do
      expect(build(:user, role: :guest).editor_or_admin?).to be false
    end
  end
end
