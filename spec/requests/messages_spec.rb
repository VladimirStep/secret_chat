require 'rails_helper'

RSpec.describe 'Requests to MessagesController', type: :request do
  let(:current_user) { create(:user) }
  let(:chat_room) { create(:chat_room) }
  let(:headers_with_jwt) do
    json_headers.merge({ 'AUTHORIZATION' => "Bearer #{JWTCoder.encode(user_id: current_user.id)}" })
  end

  context 'with correct params' do
    let(:correct_attributes) { attributes_for(:message) }

    it 'should create new message' do
      post "/api/v1/chat_rooms/#{chat_room.id}/messages",
           params: { message: correct_attributes }.to_json,
           headers: headers_with_jwt
      expect(response.content_type).to eq('application/json')
      expect(response).to have_http_status(:success)
      expect(json).to eq({
                           message: {
                             id: chat_room.messages.last.id,
                             body: correct_attributes[:body]
                           }
                         })
    end

    describe 'for existing chat room messages' do
      before(:each) do
        5.times { create(:message, chat_room: chat_room) }
        @messages = chat_room.messages
        @message = @messages.first
      end

      it 'should return collection of chat room messages' do
        get "/api/v1/chat_rooms/#{chat_room.id}/messages", headers: headers_with_jwt
        expect(response.content_type).to eq('application/json')
        expect(response).to have_http_status(:success)
        expect(json).to eq({
                             messages: @messages
                                         .select(:id, :body)
                                         .map { |r| r.attributes.symbolize_keys }
                           })
      end

      it 'should get particular message' do
        get "/api/v1/chat_rooms/#{chat_room.id}/messages/#{@message.id}",
            headers: headers_with_jwt
        expect(response.content_type).to eq('application/json')
        expect(response).to have_http_status(:success)
        expect(json).to eq({
                             message: {
                               id: @message.id,
                               body: @message.body
                             }
                           })
      end

      context 'where current user is message author' do
        before(:each) do
          @message.author = current_user
          @message.save
        end

        it 'should update message' do
          put "/api/v1/chat_rooms/#{chat_room.id}/messages/#{@message.id}",
              params: { message: correct_attributes }.to_json,
              headers: headers_with_jwt
          expect(response.content_type).to eq('application/json')
          expect(response).to have_http_status(:success)
          expect(json).to eq({
                               message: {
                                 id: @message.id,
                                 body: correct_attributes[:body]
                               }
                             })
        end

        it 'should delete message' do
          delete "/api/v1/chat_rooms/#{chat_room.id}/messages/#{@message.id}",
              headers: headers_with_jwt
          expect(response.content_type).to eq('application/json')
          expect(response).to have_http_status(:success)
          expect(json).to eq({ message: 'deleted' })
        end
      end

      context 'where current user is not author of the message' do
        it 'should not update message and return access error' do
          put "/api/v1/chat_rooms/#{chat_room.id}/messages/#{@message.id}",
              params: { message: correct_attributes }.to_json,
              headers: headers_with_jwt
          expect(response.content_type).to eq('application/json')
          expect(response).to have_http_status(:unauthorized)
          expect(json).to eq({
                               error: "You don't have permission to update this message"
                             })
        end

        it 'should not delete message and return access error' do
          delete "/api/v1/chat_rooms/#{chat_room.id}/messages/#{@message.id}",
                 headers: headers_with_jwt
          expect(response.content_type).to eq('application/json')
          expect(response).to have_http_status(:unauthorized)
          expect(json).to eq({
                               error: "You don't have permission to update this message"
                             })
        end
      end
    end
  end

  context 'with incorrect params' do
    let(:incorrect_attributes) { attributes_for(:message, body: nil) }

    it 'should not create message and return errors' do
      post "/api/v1/chat_rooms/#{chat_room.id}/messages",
           params: { message: incorrect_attributes }.to_json,
           headers: headers_with_jwt
      expect(response.content_type).to eq('application/json')
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json).to eq({
                           errors: ["Body can't be blank"]
                         })
    end

    describe 'for existing chat room messages' do
      before(:each) { @message = create(:message, chat_room: chat_room) }

      context 'where current user is message author' do
        before(:each) do
          @message.author = current_user
          @message.save
        end

        it 'should not update message and return errors' do
          put "/api/v1/chat_rooms/#{chat_room.id}/messages/#{@message.id}",
              params: { message: incorrect_attributes }.to_json,
              headers: headers_with_jwt
          expect(response.content_type).to eq('application/json')
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json).to eq({
                               errors: ["Body can't be blank"]
                             })
        end
      end
    end
  end
end
