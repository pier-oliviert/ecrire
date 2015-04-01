Ecrire::Theme::Engine.post_path = '/:post.year/:post.month/:post.slug/'

Ecrire::Theme::Engine.routes.draw do
  root 'posts#index'
  
  get '/:year/:month/:id', controller: :posts, action: :show, constraints: { year: /\d+/, month: /\d+/ }, as: "post"
  get '/feed', controller: :posts, action: :index, defaults: { format: :rss }

  resources :posts, only: [:index]

  resources :tags

  get '/:view', to: 'static#show'

end

