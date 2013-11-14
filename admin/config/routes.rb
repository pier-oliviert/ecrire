Admin::Engine.routes.draw do
  root "posts#index"
  resources :posts
end
