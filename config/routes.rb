PothiboCom::Application.routes.draw do
  root 'posts#index'

  resources :posts, only: [:show, :index]

  resource :session, only: [:create, :destroy]

  mount Admin::Engine, at: 'admin'

end
