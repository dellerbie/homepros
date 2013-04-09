Homepros::Application.routes.draw do

  devise_for :users, controllers: {
    registrations: 'registrations'
  }
  
  resources :listings, only: [:index, :show, :edit, :update]
  
  resources :preview_photos, only: :create
  
  root :to => 'listings#index'
  
end
