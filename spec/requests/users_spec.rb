require 'rails_helper'

RSpec.describe 'Requests to Users controller', type: :request do
  let(:current_user) { create(:user) }

  context 'with correct params' do
    let(:user_attributes) { attributes_for(:user)
                              .merge(password_confirmation: 'password') }

    it 'should create new user' do
      post '/api/v1/users',
           params: { user: user_attributes }.to_json,
           headers: json_headers
      user = User.last
      expect(response.content_type).to eq('application/json')
      expect(response).to have_http_status(:success)
      expect(json).to eq({
                           user: {
                             id: user.id,
                             email: user.email,
                             token: JWTCoder.encode(user_id: user.id)
                           }
                         })
    end

    it 'should return user data on edit' do
      sign_in(current_user)
      get '/api/v1/users/edit', headers: json_headers
      expect(response.content_type).to eq('application/json')
      expect(response).to have_http_status(:success)
      expect(json).to eq({
                           user: { id: current_user.id,
                                   email: current_user.email }
                         })
    end

    it 'should update user data' do
      sign_in(current_user)
      put '/api/v1/users',
          params: { user: user_attributes
                            .merge({ current_password: 'password' }) }.to_json,
          headers: json_headers
      expect(response.content_type).to eq('application/json')
      expect(response).to have_http_status(:success)
      expect(json).to eq({
                           user: { id: current_user.id,
                                   email: user_attributes[:email] }
                         })
    end

    it 'should destroy current user' do
      sign_in(current_user)
      delete '/api/v1/users', headers: json_headers
      expect(response.content_type).to eq('application/json')
      expect(response).to have_http_status(:success)
      expect(json).to eq({ message: 'deleted' })
    end
  end

  context 'with wrong params' do
    let(:wrong_attributes) { attributes_for(:user)
                              .merge(password_confirmation: 'wrong') }

    it 'should return errors' do
      post '/api/v1/users',
           params: { user: wrong_attributes }.to_json,
           headers: json_headers
      expect(response.content_type).to eq('application/json')
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json).to eq({
                            errors: ["Password confirmation doesn't match Password"]
                         })
    end

    it 'should not update user data, and should return essors' do
      sign_in(current_user)
      put '/api/v1/users',
          params: { user: wrong_attributes
                            .merge({ current_password: 'password' }) }.to_json,
          headers: json_headers
      expect(response.content_type).to eq('application/json')
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json).to eq({
                           errors: ["Password confirmation doesn't match Password"]
                         })
    end
  end
end