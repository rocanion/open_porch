Rails.application.routes.draw do

  resources :passwords, :only => [:new, :create, :edit, :update]
  post  '/login' => 'sessions#create'
  get   '/login' => 'sessions#new'
  get   '/logout' => 'sessions#destroy'

  resources :registrations
  resource  :user
  get '/verify-email/:email_verification_key' => 'users#verify_email', :as => :verify_email
  get '/resend-email-verification/:email_verification_key' => 'users#resend_email_verification', :as => :resend_email_verification
    
  resources :areas, :only => :show do
    get '/current-issue' => 'areas/issues#current', :as => :current_issue
    resources :issues, :controller => 'areas/issues', :only => [:index, :show] do
      collection do
        get '/:year/:month', :action => :index, :as => :archive
      end
    end
    resources :posts, :controller => 'areas/posts', :only => [:index, :new, :create]
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
        member do
          post :toggle_reviewed_by
        end
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
