Homepros::Application.routes.draw do

  devise_for :users, controllers: {
    registrations: 'registrations'
  }
  
  root :to => 'index#index'
  
end
