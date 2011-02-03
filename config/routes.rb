Rails.application.routes.draw do

  resources :passwords, :only => [:new, :create, :edit, :update]
  post  '/login' => 'sessions#create'
  get   '/login' => 'sessions#new'
  get   '/logout' => 'sessions#destroy'

  resources :registrations
  resource  :user
  
  resources :areas do
    resources :posts, :only => [:new, :create]
  end
  
  namespace :admin do
    get '/' => redirect('/admin/users')
    resources :areas do
      collection do
        get :edit_borders
        post :bulk_update
      end
      resources :memberships, :controller => 'areas/memberships'
    end
    resources :users
  end
  
  root :to => 'registrations#index'
  
end
