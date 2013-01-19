Homepros::Application.routes.draw do
  resources :listings

  root :to => 'index#index'
  
  
end
