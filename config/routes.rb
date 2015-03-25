Myflix::Application.routes.draw do
  root to: 'pages#front'
  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'videos#index'
  get '/register', to: 'users#new'
  get '/sign-in', to: 'sessions#new'
  post '/sign-in', to: 'sessions#create'
  get '/log-out', to: 'sessions#destroy'
  get '/my-queue', to: 'queue_items#index'
  post '/queue-update', to: 'queue_items#queue_update'
  get '/people', to: 'relationships#index'

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
end
