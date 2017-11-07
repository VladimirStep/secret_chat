require 'rails_helper'

RSpec.describe ChatRoom, type: :model do
  it 'has valid factory' do
    expect(build(:chat_room)).to be_valid
  end


end
