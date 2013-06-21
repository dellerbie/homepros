Homepros::Application.routes.draw do
  root :to => 'listings#index'
  
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  devise_for :users, controllers: {
    registrations: 'registrations'
  }
  
  get '/search' => 'search#index'

  resources :listings, only: [:index, :show, :edit, :update] do
    member do 
      get :claim
      post :claim
    end
    
    resources :portfolio_photos, only: [:create, :destroy] do
      member do 
        post :update
        post :update_description
      end
    end
  end
  
  resources :preview_photos, only: :create
  resources :questions, only: :create
  resources :homeowners, only: :create
  resources :upgrades, only: [:new, :create, :show, :update, :destroy]
  mount StripeEvent::Engine => '/stripe' 
  
  get '/(:city_slug/(:specialty_slug))' => 'listings#index'
  
end
