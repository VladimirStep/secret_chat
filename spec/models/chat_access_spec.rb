require 'rails_helper'

RSpec.describe ChatAccess, type: :model do
  it 'has valid factory' do
    expect(build(:chat_access)).to be_valid
  end

  let(:chat_access) { build(:chat_access) }

  subject { chat_access }

  describe 'validation' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:chat_room) }
    it { should validate_presence_of(:status) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:chat_room) }
    it { should define_enum_for(:status).with([:opened, :closed]) }
  end
end
