require 'rails_helper'

RSpec.describe Profile, type: :model do
  it 'has valid factory' do
    expect(build(:profile)).to be_valid
  end

  let(:profile) { build(:profile) }

  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:gender) }
    it { should validate_length_of(:first_name).is_at_most(50) }
    it { should validate_length_of(:last_name).is_at_most(50) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should define_enum_for(:gender).with([:male, :female]) }
  end
end
