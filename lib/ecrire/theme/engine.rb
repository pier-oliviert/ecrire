module Ecrire
  ##
  # Theme module links the user's theme with 
  # Ecrire::Application. It uses Rails::Engine to hook
  # itself up and split the codebase between the Gem and the user's
  # Theme.
  #
  module Theme

    ##
    # Engine is the foundation of Rails. It can be used
    # to encapsulate part of the application and this is 
    # exactly what it does here.
    #
    # Ecrire::Theme::Engine is the block that hooks into Ecrire::Application
    # to provide Theme support.
    #
    # This class is the only element that the Gem includes at runtime.
    # 
    # Everything else is defined in the user's theme folder.
    #
    # This engine is the reason why it's possible to have 
    # Ecrire as a gem and theme as user's folder.
    #
    class Engine < Rails::Engine

      ##
      # +post_path+ needs to be defined so Ecrire can link from the admin
      # to a post. This is also needed when listing all the titles a post has
      # and the URL they represent.
      #
      attr_accessor :post_path

      ##
      # Return paths for a theme. The paths
      # follow the structure of the default theme.
      #
      # It creates a new Rails::Paths because 
      # it's highly customized and it was less readable to
      # disable and changes every paths.
      #
      # This could be modified in the user's theme.
      #
      #
      def paths
        @paths ||= begin
          paths = Rails::Paths::Root.new(Ecrire::Theme.path)
          paths.add 'app/views', with: 'views'
          paths.add 'app/controllers', with: 'controllers', eager_load: true
          paths.add 'app/assets', with: 'assets', glob: '*'
          paths.add 'app/helpers', with: 'helpers', eager_load: true

          paths.add 'config/routes.rb', with: 'routes.rb'
          paths.add 'config/locales', with: 'locales', glob: '**/*.{rb,yml}'
          paths.add 'config/environments', with: 'environments', glob: "#{Rails.env}.rb"

          paths.add 'public', with: 'tmp/public'

          paths.add "lib/assets",          glob: "*"
          paths.add "vendor/assets",       glob: "*"
          paths.add "lib/tasks"

          paths
        end
      end

      ##
      # Disables migration for now.
      # Any Rails::Engine instance can support migrations
      # which means that Theme could have their own
      # models.
      #
      # It's likely that at some point this behavior is resumed but
      # I want to make sure that I understand the implication before
      # turning this back on.
      #
      # For example, I would like to make sure that the Admin is shelled from
      # those future migrations. 
      def has_migrations?
        false
      end

      ##
      # Return the root_path for the current theme
      #
      # The method starts at the current working directory and moves from parent
      # to parent until it either finds +config.ru+ or it reaches the root.
      #
      # Raise an error if it reaches the root and can't find +config.ru+.
      #
      def root_path(file = 'config.ru')
        begin
          pathname = Pathname.pwd

          while !(pathname + file).exist? do
            pathname = pathname.parent
            if pathname.root?
              raise "Could not find #{file}. Type 'ecrire new blog_name' to create a new blog"
              break
            end
          end

          pathname
        end
      end

      initializer 'ecrire.logs', before: :initialize_logger do |app|
        unless Rails.env.test?
          app.paths.add "log", with: "log/#{Rails.env}.log"
        end
      end

      initializer 'ecrire.load_paths', before: :bootstrap_hook do |app|
        ActiveSupport::Dependencies.autoload_paths.unshift(*self.paths.autoload_paths)
        ActiveSupport::Dependencies.autoload_once_paths.unshift(*self.paths.autoload_once)

        if self.paths['public'].existent.any?
          app.paths.add 'public', with: self.paths['public'].existent
        end
      end

      initializer 'ecrire.append_paths', before: :set_autoload_paths do |app|
        app.config.eager_load_paths.unshift(*paths.eager_load)
        app.config.autoload_once_paths.unshift(*paths.autoload_once)
        app.config.autoload_paths.unshift(*paths.autoload_paths)
      end


    end
  end
end
