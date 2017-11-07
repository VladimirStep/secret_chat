require 'rails_helper'

RSpec.describe 'Requests to ProfilesController', type: :request do
  let(:current_user) { create(:user) }
  let(:headers_with_jwt) do
    json_headers.merge({ 'AUTHORIZATION' => "Bearer #{JWTCoder.encode(user_id: current_user.id)}" })
  end

  context 'with correct params' do
    let(:correct_attributes) { attributes_for(:profile) }

    it 'should create user profile' do
      post '/api/v1/profile',
           params: { profile: correct_attributes }.to_json,
           headers: headers_with_jwt
      expect(response.content_type).to eq('application/json')
      expect(response).to have_http_status(:success)
      expect(json).to eq({
                           profile: {
                             first_name: correct_attributes[:first_name],
                             last_name: correct_attributes[:last_name],
                             gender: correct_attributes[:gender]
                           }
                         })
    end

    describe 'for existing profile' do
      before(:each) do
        @current_user_profile = create(:profile, user: current_user)
      end

      it 'should get user profile data' do
        get '/api/v1/profile', headers: headers_with_jwt
        expect(response.content_type).to eq('application/json')
        expect(response).to have_http_status(:success)
        expect(json).to eq({
                             profile: {
                               first_name: @current_user_profile.first_name,
                               last_name: @current_user_profile.last_name,
                               gender: @current_user_profile.gender
                             }
                           })
      end

      it 'should update profile data' do
        put '/api/v1/profile',
            params: { profile: correct_attributes }.to_json,
            headers: headers_with_jwt
        expect(response.content_type).to eq('application/json')
        expect(response).to have_http_status(:success)
        expect(json).to eq({
                             profile: {
                               first_name: correct_attributes[:first_name],
                               last_name: correct_attributes[:last_name],
                               gender: correct_attributes[:gender]
                             }
                           })
      end

      it 'should delete current profile' do
        delete '/api/v1/profile', headers: headers_with_jwt
        expect(response.content_type).to eq('application/json')
        expect(response).to have_http_status(:success)
        expect(json).to eq({ message: 'deleted' })
      end
    end
  end

  context 'with incorrect params' do
    let(:incorrect_attributes) { attributes_for(:profile, first_name: nil) }

    it 'should not create user profile and return errors' do
      post '/api/v1/profile',
           params: { profile: incorrect_attributes }.to_json,
           headers: headers_with_jwt
      expect(response.content_type).to eq('application/json')
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json).to eq({
                           errors: ["First name can't be blank"]
                         })
    end

    describe 'for existing profile' do
      before(:each) do
        @current_user_profile = create(:profile, user: current_user)
      end

      it 'should not update profile data and return errors' do
        put '/api/v1/profile',
            params: { profile: incorrect_attributes }.to_json,
            headers: headers_with_jwt
        expect(response.content_type).to eq('application/json')
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json).to eq({
                             errors: ["First name can't be blank"]
                           })
      end
    end
  end
end
