require 'rails_helper'

RSpec.describe Message, type: :model do
  it 'has valid factory' do
    expect(build(:message)).to be_valid
  end

  let(:message) { build(:message) }

  subject { message }

  describe 'validations' do
    it { should validate_presence_of(:body) }
    it { should validate_presence_of(:author) }
    it { should validate_presence_of(:chat_room) }
  end

  describe 'associations' do
    it { should belong_to(:author).class_name('User').with_foreign_key(:user_id) }
    it { should belong_to(:chat_room) }
  end

  context 'callbacks' do
    it { should callback(:filter_text).before(:save) }

    describe '#filter_text replace words on save' do
      let(:new_message) { create(:message, body: 'Text with bad_word in body') }

      it 'should not contain bad_word' do
        expect(new_message.body).not_to match(/bad_word/)
      end

      it 'should not contain ***' do
        expect(new_message.body).to match(/\*\*\*/)
      end
    end
  end

  describe 'public instance methods' do
    context 'responds to its methods' do
      it { should respond_to(:user_is_author?) }
    end

    context 'executes methods correctly' do
      context '#user_is_author?' do
        let(:other_user) { create(:user) }

        it 'checks current message authorship' do
          expect(message.user_is_author?(message.author)).to be_truthy
          expect(message.user_is_author?(other_user)).to be_falsey
        end
      end
    end
  end
end
