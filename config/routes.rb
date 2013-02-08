Homepros::Application.routes.draw do

  devise_for :users, controllers: {
    registrations: 'registrations'
  }

  resources :listings
  
  root :to => 'index#index'
  
end
