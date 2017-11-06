require 'rails_helper'

RSpec.describe 'Requests to Users controller', type: :request do
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
  end
end