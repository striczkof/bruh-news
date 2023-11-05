Rails.application.routes.draw do
  namespace :models do
    get 'comments/get_from_article'
    get 'comments/create'
    get 'comments/delete'
    get 'comments/edit'
  end
  #map.connect '/:action', :controller => "main", :action => /index|categories|search/
  # Index/Root
  root 'main#index'
  # Categories
  get '/categories', to: 'main#categories'
  # Categories
  get '/search', to: 'main#search'
  # Account stuff
  # Login
  get '/login', to: 'account#login'
  post '/login', to: 'account#login'
  # Logout
  get '/logout', to: 'account#logout'
  # Register
  get '/register', to: 'account#register'
  post '/register', to: 'account#register'
  # User settings
  get '/settings', to: 'account#settings'
  post '/settings', to: 'account#settings'
  # Show article
  get '/article/:id', to: 'main#article'
  # Show category
  get '/category/:id', to: 'main#category'
  #

  # Admin panel
  get '/admin', to: 'admin#index'
  post '/admin', to: 'admin#index'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
