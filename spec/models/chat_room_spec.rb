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
    it { should have_many(:visitors).class_name('User').through(:chat_accesses) }
  end

  describe 'public instance methods' do
    context 'responds to its methods' do
      it { should respond_to(:has_granted_access?) }
    end

    context 'executes methods correctly' do
      context '#has_granted_access?' do
        let(:other_user) { create(:user) }
        let(:visitor) { create(:user) }
        let(:old_visitor) { create(:user) }

        before(:each) do
          create(:chat_access, user: visitor, chat_room: chat_room, status: 'opened')
          create(:chat_access, user: old_visitor, chat_room: chat_room, status: 'closed')
        end

        it 'check access to chat room' do
          expect(chat_room.has_granted_access?(chat_room.owner)).to be_truthy
          expect(chat_room.has_granted_access?(other_user)).to be_falsey
          expect(chat_room.has_granted_access?(visitor)).to be_truthy
          expect(chat_room.has_granted_access?(old_visitor)).to be_falsey
        end
      end
    end
  end
end
