Homepros::Application.routes.draw do

  devise_for :users, controllers: {
    registrations: 'registrations'
  }
  
  resources :listings, only: [:index, :show, :edit, :update] do
    match :claim, via: [:get, :post], on: :member
  end
  resources :preview_photos, only: :create
  resources :questions, only: [:create]
  
  get '/(:city_slug/(:specialty_slug))' => 'listings#index'
  
  root :to => 'listings#index'
  
end
