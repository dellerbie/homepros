Homepros::Application.routes.draw do

  devise_for :users, controllers: {
    registrations: 'registrations'
  }
  
  resource :listings, only: [:index, :show]
  
  root :to => 'listings#index'
  
end
