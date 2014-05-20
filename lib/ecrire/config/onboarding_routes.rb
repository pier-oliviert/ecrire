Ecrire::Application.routes.draw do

  root 'onboarding#index'

  namespace :onboarding, only: :index do
    get 'complete'
    resources :databases, only: [:index, :create]
    resources :users, only: [:index, :create]
  end
end


