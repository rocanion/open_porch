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
      resources :issues do
        member do
          post :add_posts
          post :remove_posts
        end
      end
      collection do
        get :edit_borders
        post :bulk_update
      end
    end
    resources :users
    resources :posts
  end
  
  root :to => 'registrations#index'
  
end
