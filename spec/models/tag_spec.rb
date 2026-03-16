require "rails_helper"

RSpec.describe Tag, type: :model do
  describe "validations" do
    subject { create(:tag) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should validate_length_of(:name).is_at_most(50) }
  end

  describe "associations" do
    it { should have_and_belong_to_many(:articles) }
  end
end
