OpenPorch::Application.routes.draw do

  resources :registrations
  resources :areas
  
  namespace :admin do
    resources :areas
    resources :users
  end
  
  root :to => 'registrations#index'
  
end
