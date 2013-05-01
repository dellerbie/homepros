Homepros::Application.routes.draw do

  devise_for :users, controllers: {
    registrations: 'registrations'
  }
  
  resources :listings, only: [:index, :show, :edit, :update] do
    member do 
      get :claim
      post :claim
    end
  end
  
  resources :preview_photos, only: :create
  resources :questions, only: :create
  resources :upgrades, only: [:new, :create, :show, :update, :destroy]
  mount StripeEvent::Engine => '/stripe' 
  
  get '/(:city_slug/(:specialty_slug))' => 'listings#index'
  
  root :to => 'listings#index'
  
end
