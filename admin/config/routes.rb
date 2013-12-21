Admin::Engine.routes.draw do
  root "posts#index"

  resources :posts
  resources :splits
  resources :partials
end
