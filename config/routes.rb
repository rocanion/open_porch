OpenPorch::Application.routes.draw do

  resources :areas
  
  namespace :admin do
    resources :areas
    resources :users
  end
end
