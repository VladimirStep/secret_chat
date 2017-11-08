require 'rails_helper'

RSpec.describe ChatRoom, type: :model do
  it 'has valid factory' do
    expect(build(:chat_room)).to be_valid
  end

  let(:chat_room) { build(:chat_room) }

  subject { chat_room }

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(2) }
    it { should validate_length_of(:name).is_at_most(50) }
    it { should validate_length_of(:password).is_at_most(72) }
    it { should validate_confirmation_of(:password) }
    it { should validate_presence_of(:owner) }
  end

  describe 'associations' do
    it { should belong_to(:owner).class_name('User').with_foreign_key(:user_id) }
    it { should have_db_column(:password_digest).of_type(:string) }
    it { should have_many(:messages) }
    it { should have_many(:chat_accesses) }
  end
end
