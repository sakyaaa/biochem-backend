require "rails_helper"

RSpec.describe Section, type: :model do
  describe "validations" do
    subject { create(:section) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:slug) }
    it { should validate_uniqueness_of(:slug) }
    it { should validate_length_of(:name).is_at_most(100) }
  end

  describe "associations" do
    it { should have_many(:articles).dependent(:nullify) }
  end
end
