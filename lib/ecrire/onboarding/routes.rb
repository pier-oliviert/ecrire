Ecrire::Onboarding::Engine.routes.draw do

  root 'onboarding#index'

  namespace :onboarding, only: :index do
    resources :databases, only: [:index, :create]
    resources :users, only: [:index, :create]
  end
end

