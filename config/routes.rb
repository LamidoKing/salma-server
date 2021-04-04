Rails.application.routes.draw do
  root to: 'rooms#show'
  mount ActionCable.server => '/cable'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount ActionCable.server => '/cable'
  namespace :api do
    namespace :v1 do
      resources :users, only: ['create']
      post 'login', to: 'auth#login'
      get 'profile', to: 'profile#index'
      get 'helps/me', to: 'helps#me'
      post 'helps/reopen', to: 'helps#reopen'
      resources :helps, only: ['create', 'index', 'show', 'destroy', 'update']
      resources :categories, only: ['index', 'show']
      get 'categories/:id/helps', to: 'categories#helps'
      resources :chats, only: ['create']
      get 'chats/help/:help_id', to: 'chats#fetch_for_help'
    end
  end
end
