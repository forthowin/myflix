Myflix::Application.routes.draw do
  root to: 'pages#front'

  get 'ui(/:action)', controller: 'ui'

  get '/home', to: 'videos#index'

  get '/register', to: 'users#new'
  get '/register/:token', to: 'users#new_with_invitation_token', as: :register_with_token

  get '/sign-in', to: 'sessions#new'
  post '/sign-in', to: 'sessions#create'
  get '/log-out', to: 'sessions#destroy'

  get '/my-queue', to: 'queue_items#index'
  post '/queue-update', to: 'queue_items#queue_update'

  get '/people', to: 'relationships#index'

  get '/forgot-password-confirmation', to: 'forgot_passwords#confirm'
  get '/forgot-password', to: 'forgot_passwords#new'
  
  get '/invalid-token', to: 'pages#invalid_token'

  get '/invite', to: 'invitations#new'

  resources :users, only: [:create, :show]
  resources :videos, only: :show do
    collection do
      get :search
    end
    resources :reviews, only: :create
  end
  resources :categories, only: [:show]
  resources :queue_items, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :reset_passwords, only: [:show, :create]
  resources :forgot_passwords, only: [:create]
  resources :invitations, only: [:create]

  namespace :admin do
    resources :videos, only: [:new, :create]
  end
end
