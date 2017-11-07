Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'chat_rooms#index'

  scope 'api/v1' do
    devise_for :users,
               defaults: { format: :json },
               controllers: { sessions: 'api/v1/sessions',
                              registrations: 'api/v1/registrations' }
  end

  namespace :api do
    namespace :v1 do
      resource :profile, only: [:create, :show, :update, :destroy],
                         defaults: { format: :json }
      resources :chat_rooms, except: [:new, :edit], defaults: { format: :json }
    end
  end
end
