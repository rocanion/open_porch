Rails.application.routes.draw do

  resources :passwords, :only => [:new, :create, :edit, :update]
  post '/login' => 'sessions#create'
  get '/login' => 'sessions#new'
  get '/logout' => 'sessions#destroy'

  resources :registrations
  resources :users
  
  resources :areas do
    resources :posts, :only => [:new, :create]
  end
  
  get '/admin' => 'admin/areas#index'
  namespace :admin do
    resources :areas
    resources :users
  end
  
  root :to => 'registrations#index'
  
end
