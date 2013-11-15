PothiboCom::Application.routes.draw do
  root 'posts#index'

  get '/:year/:month/:id', to: 'posts#show', constraints: { year: /\d+/, month: /\d+/ }, as: "post"

  resources :posts, only: [:index]

  resource :session, only: [:create, :destroy]

  mount Admin::Engine, at: 'admin'

end
