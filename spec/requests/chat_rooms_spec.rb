require 'rails_helper'

RSpec.describe 'Requests to ChatRoomsController', type: :request do
  let(:current_user) { create(:user) }
  let(:headers_with_jwt) do
    json_headers.merge({ 'AUTHORIZATION' => "Bearer #{JWTCoder.encode(user_id: current_user.id)}" })
  end

  context 'with correct params' do
    let(:correct_attributes) { attributes_for(:chat_room)
                                 .merge({ password_confirmation: 'password' }) }

    it 'should create new chat room' do
      post '/api/v1/chat_rooms',
           params: { chat_room: correct_attributes }.to_json,
           headers: headers_with_jwt
      expect(response.content_type).to eq('application/json')
      expect(response).to have_http_status(:success)
      expect(json).to eq({
                          chat_room: {
                            id: current_user.chat_rooms.last.id,
                            name: correct_attributes[:name]
                          }
                         })
    end

    describe 'for existing chat rooms' do
      before(:each) do
        5.times { create(:chat_room, owner: current_user) }
        @all_user_chat_rooms = current_user.chat_rooms
        @current_chat_room = @all_user_chat_rooms.first
      end

      it 'should return collection of user chat rooms' do
        get '/api/v1/chat_rooms', headers: headers_with_jwt
        expect(response.content_type).to eq('application/json')
        expect(response).to have_http_status(:success)
        expect(json).to eq({
                            chat_rooms: @all_user_chat_rooms
                                          .select(:id, :name)
                                          .map { |r| r.attributes.symbolize_keys }
                           })
      end

      it 'should get user chat room' do
        get "/api/v1/chat_rooms/#{@current_chat_room.id}",
            headers: headers_with_jwt
        expect(response.content_type).to eq('application/json')
        expect(response).to have_http_status(:success)
        expect(json).to eq({
                             chat_room: {
                               id: @current_chat_room.id,
                               name: @current_chat_room.name
                             }
                           })
      end

      it 'should update chat room data' do
        put "/api/v1/chat_rooms/#{@current_chat_room.id}",
            params: { chat_room: correct_attributes }.to_json,
            headers: headers_with_jwt
        expect(response.content_type).to eq('application/json')
        expect(response).to have_http_status(:success)
        expect(json).to eq({
                             chat_room: {
                               id: @current_chat_room.id,
                               name: correct_attributes[:name]
                             }
                           })
      end

      it 'should delete chat room' do
        delete "/api/v1/chat_rooms/#{@current_chat_room.id}",
            headers: headers_with_jwt
        expect(response.content_type).to eq('application/json')
        expect(response).to have_http_status(:success)
        expect(json).to eq({ message: 'deleted' })
      end
    end
  end

  context 'with incorrect params' do
    let(:incorrect_attributes) { attributes_for(:chat_room, name: nil) }

    it 'should not create chat room and return errors' do
      post '/api/v1/chat_rooms',
           params: { chat_room: incorrect_attributes }.to_json,
           headers: headers_with_jwt
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json).to eq({
                           errors: ["Name can't be blank",
                                    "Name is too short (minimum is 2 characters)"]
                         })
    end

    describe 'for existing chat room' do
      before(:each) do
        @current_chat_room = create(:chat_room, owner: current_user)
      end

      it 'should not update chat room data and return errors' do
        put "/api/v1/chat_rooms/#{@current_chat_room.id}",
            params: { chat_room: incorrect_attributes }.to_json,
            headers: headers_with_jwt
        expect(response.content_type).to eq('application/json')
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json).to eq({
                             errors: ["Name can't be blank",
                                      "Name is too short (minimum is 2 characters)"]
                           })
      end
    end
  end
end
