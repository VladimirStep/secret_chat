require 'rails_helper'

RSpec.describe Message, type: :model do
  it 'has valid factory' do
    expect(build(:message)).to be_valid
  end

  let(:message) { build(:message) }

  describe 'validations' do
    it { should validate_presence_of(:body) }
    it { should validate_presence_of(:author) }
    it { should validate_presence_of(:chat_room) }
  end

  describe 'associations' do
    it { should belong_to(:author).class_name('User').with_foreign_key(:user_id) }
    it { should belong_to(:chat_room) }
  end
end
