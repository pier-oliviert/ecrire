Ecrire::Application.routes.draw do

  if defined?(Ecrire::Theme::Engine)
    resource :session, only: [:new, :create, :destroy]

    namespace :admin do
      root 'posts#index'
      resources :tags
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

    mount Ecrire::Theme::Engine => '/', as: 'theme'
  else
    mount Ecrire::Onboarding::Engine => '/'
  end

end
