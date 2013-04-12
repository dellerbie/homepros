Homepros::Application.routes.draw do

  devise_for :users, controllers: {
    registrations: 'registrations'
  }
  
  resources :listings, only: [:index, :show, :edit, :update]
  
  resources :preview_photos, only: :create
  
  get '/(:city_slug/(:specialty_slug)/(:budget_slug))' => 'listings#index'
  
  root :to => 'listings#index'
  
end
