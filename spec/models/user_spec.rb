require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has valid factory' do
    expect(build(:user)).to be_valid
  end

  let(:current_user) { build(:user) }

  subject { current_user }

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should allow_value('user@example.com').for(:email) }
    it { should_not allow_value('not-an-email').for(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(6) }
    it { should validate_length_of(:password).is_at_most(128) }
  end

  describe 'database' do
    it { should have_db_index(:email).unique(:true) }
    it { should have_db_column(:provider).of_type(:string) }
    it { should have_db_column(:uid).of_type(:string) }
  end

  describe 'associations' do
    it { should have_one(:profile) }
    it { should have_many(:chat_rooms) }
    it { should have_many(:messages) }
    it { should have_many(:chat_accesses) }
    it { should have_many(:chats).class_name('ChatRoom').through(:chat_accesses) }
  end
end
