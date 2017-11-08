require 'rails_helper'

RSpec.describe 'Requests to ChatAccessesController', type: :request do
  let(:current_user) { create(:user) }
  let(:chat_room) { create(:chat_room) }
  let(:headers_with_jwt) do
    json_headers.merge({ 'AUTHORIZATION' => "Bearer #{JWTCoder.encode(user_id: current_user.id)}" })
  end

  context 'with correct credentials' do
    let(:correct_password) { { password: 'password' } }

    it 'should create access by password' do
      post "/api/v1/chat_rooms/#{chat_room.id}/chat_access",
           params: { chat_room: correct_password }.to_json,
           headers: headers_with_jwt
      expect(response.content_type).to eq('application/json')
      expect(response).to have_http_status(:success)
      expect(json).to eq({ message: 'Access opened' })
    end

    describe 'should close access' do
      before(:each) do
        @access = create(:chat_access,
                         user: current_user,
                         chat_room: chat_room,
                         status: 'opened')
      end

      it 'close access to chat' do
        delete "/api/v1/chat_rooms/#{chat_room.id}/chat_access",
               headers: headers_with_jwt
        expect(response.content_type).to eq('application/json')
        expect(response).to have_http_status(:success)
        expect(json).to eq({ message: 'Access closed' })
        expect(@access.reload.closed?).to be_truthy
      end
    end
  end

  context 'with incorrect credentials' do
    let(:incorrect_password) { { password: 'incorrect' } }

    it 'should create access by password' do
      post "/api/v1/chat_rooms/#{chat_room.id}/chat_access",
           params: { chat_room: incorrect_password }.to_json,
           headers: headers_with_jwt
      expect(response.content_type).to eq('application/json')
      expect(response).to have_http_status(:unauthorized)
      expect(json).to eq({ error: "You don't have permission to access this chat" })
    end

    describe 'should not close access' do
      let(:other_user) { create(:user) }

      before(:each) do
        @access = create(:chat_access,
                         user: other_user,
                         chat_room: chat_room,
                         status: 'opened')
      end

      it 'does not close access and return error' do
        delete "/api/v1/chat_rooms/#{chat_room.id}/chat_access",
               headers: headers_with_jwt
        expect(response.content_type).to eq('application/json')
        expect(response).to have_http_status(:unauthorized)
        expect(json).to eq({ error: "You don't have permission to change this access" })
        expect(@access.reload.closed?).to be_falsey
      end
    end
  end
end
