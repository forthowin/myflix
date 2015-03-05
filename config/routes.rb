Myflix::Application.routes.draw do
  root to: 'pages#front'
  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'videos#index'
  get '/register', to: 'users#new'
  get '/sign-in', to: 'sessions#new'

  resources :users, only: :create
  resources :videos, only: :show do
    collection do
      get :search
    end
  end
  resources :categories, only: :show
end
