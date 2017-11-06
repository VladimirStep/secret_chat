require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  let(:user) { create(:user) }

  it 'returns error when user provides wrong credentials' do
    post '/api/v1/users/sign_in',
         params: { user: { email: user.email, password: 'wrong' } }.to_json,
         headers: json_headers
    expect(response.content_type).to eq('application/json')
    expect(response).to have_http_status(:unauthorized)
    expect(json).to eq({ error: 'Invalid Email or password.' })
  end

  it 'returns success when user provides correct credentials' do
    post '/api/v1/users/sign_in',
         params: { user: { email: user.email, password: 'password' } }.to_json,
         headers: json_headers
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