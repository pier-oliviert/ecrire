Ecrire::Onboarding::Engine.routes.draw do

  root 'onboarding#index'

  resources :databases, only: [:index, :create]
  resources :users, only: [:index, :create]
end

