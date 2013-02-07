Homepros::Application.routes.draw do
  devise_for :users

  resources :listings

  root :to => 'index#index'
  
  
end
