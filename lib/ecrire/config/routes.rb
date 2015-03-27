Ecrire::Application.routes.draw do

  resource :session, only: [:new, :create, :destroy]

  resources :partials, only: [:show]

  namespace :admin do
    root 'posts#index'
    resources :posts do
      collection do
        get 'help', controller: :posts, action: :help
      end
      resources :tags, only: [:index, :create, :update], module: 'posts'
      resources :titles, shallow: true
      resource :image, shallow: true
      resource :properties, only: [:create, :destroy]
    end

    namespace :configurations do
      resource :images, only: [:show, :create]
    end
  end

  get '/:view', to: 'static#show'

end
