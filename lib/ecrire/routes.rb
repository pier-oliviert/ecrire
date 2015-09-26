Ecrire::Application.routes.draw do

  if defined?(Ecrire::Theme::Engine)
    resource :session, only: [:new, :create, :destroy]

    namespace :admin do
      root 'posts#index'

      resource :profile

      resources :tags
      resources :posts do
        put :toggle
        collection do
          get 'help', controller: :posts, action: :help
          get :drafts
          get :published
        end

        resources :tags, only: [:index, :create], module: 'posts' do
          put :toggle
        end

        resources :titles, only: [:index, :update, :create], module: 'posts' do

        end

        resource :image, shallow: true
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
