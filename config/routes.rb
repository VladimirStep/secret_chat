Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'chat_rooms#index'

  scope 'api/v1' do
    devise_for :users, defaults: { format: :json }
  end
end
