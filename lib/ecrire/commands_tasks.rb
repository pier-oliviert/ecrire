require 'rails/commands/commands_tasks'
require 'ecrire/version'
require 'active_record'

module Ecrire
  class CommandsTasks < Rails::CommandsTasks

    COMMAND_WHITELIST = %w(console server new version help)

    # I have to reimplement the whole method otherwise it will
    # check against the parent's COMMAND_WHITELIST
    def run_command!(command)
      command = parse_command(command)
      if COMMAND_WHITELIST.include?(command)
        send(command)
      else
        write_error_message(command)
      end
    end

    def server
      require_command!("server")

      server = Ecrire::Server.new.tap do |server|
        # We need to require application after the server sets environment,
        # otherwise the --environment option given to the server won't propagate.
        require 'ecrire'
        Dir.chdir(Ecrire::Application.root)
        if Ecrire::Railtie.configured?
          check_migration_pending!
        end
      end

      if Rails.env.production?
        require_command!('assets')
        Ecrire::Assets.new(server.app).compile!
      end

      server.start

    end


    def console
      require_command!("console")
      options = Rails::Console.parse_arguments(argv)

      # RAILS_ENV needs to be set before config/application is required
      ENV['RAILS_ENV'] = options[:environment] if options[:environment]
      #
      # shift ARGV so IRB doesn't freak
      shift_argv!

      initialize_application!
      if Ecrire::Railtie.configured?
        check_migration_pending!
      end
      Ecrire::Console.start(Ecrire::Application, options)
    end

    def new
      name = ARGV.shift
      if name.nil?
        raise 'You need to specify a name for your new blog'
      end

      require_command!('new')
      Ecrire::New.generate! name
    end

    def version
      puts "Ecrire #{Ecrire::VERSION}"
    end

    def initialize_application!
      require 'ecrire'
      Ecrire::Application.initialize!
    end

    def require_command!(command)
      require "ecrire/commands/#{command}"
    end

    protected

    def check_migration_pending!
      path = Rails.application.paths['db/migrate'].existent
      migration = ActiveRecord::Migrator.migrations(path).last
      current_version = ActiveRecord::Migrator.get_all_versions.max
      if migration.version > current_version
        puts 'Your database needs to be updated. You may want to backup your database beforehand. Would you like to do it now? (y/n)'
        while a = gets
          if a[0].casecmp('y') == 0
            ActiveRecord::Migrator.migrate(path)
            break
          else
            exit
          end
        end
      end
    end

  end
end
