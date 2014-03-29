PothiboCom::Application.routes.draw do
  root 'posts#index'

  get '/:year/:month/:id', to: 'posts#show', constraints: { year: /\d+/, month: /\d+/ }, as: "post"
  get '/feed', to: 'posts#index', defaults: { format: :rss }

  resources :posts, only: [:index]

  resource :session, only: [:create, :destroy]

  resources :partials, only: [:show]
  resources :images, only: [:show]

  namespace :admin do
    root 'posts#index'
    resources :posts do
      resources :images, shallow: true
    end
    resources :partials
  end

end
