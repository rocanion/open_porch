Rails.application.routes.draw do

  resources :passwords, :only => [:new, :create, :edit, :update]
  post  '/login' => 'sessions#create'
  get   '/login' => 'sessions#new'
  get   '/logout' => 'sessions#destroy'

  resources :registrations
  resource  :user
  
  resources :areas, :only => :show do
    resources :posts, :only => [:new, :create]
  end
  
  namespace :admin do
    get '/' => redirect('/admin/areas')
    resources :areas do
      resources :issues, :controller => 'areas/issues' do
        member do
          post :add_posts
          post :remove_posts
        end
      end
      resources :posts, :controller => 'areas/posts' do
        collection do
          put :order, :as => :order
        end
      end
      member do
        get :edit_borders
      end
      collection do
        post :bulk_update
      end
      resources :memberships, :controller => 'areas/memberships'
    end
    resources :users
    resources :user_activity
  end
  
  root :to => 'registrations#index'
  
end
