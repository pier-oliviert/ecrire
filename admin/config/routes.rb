Admin::Engine.routes.draw do
  root "posts#index"

  resources :posts
  resources :tests
  resources :partials
end
