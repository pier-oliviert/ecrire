require 'rails/commands/commands_tasks'
require 'ecrire/version'

module Ecrire
  class CommandsTasks < Rails::CommandsTasks

    COMMAND_WHITELIST = %w(console server new update version help)

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
      set_application_directory!
      require_command!("server")

      Rails::Server.new.tap do |server|
        # We need to require application after the server sets environment,
        # otherwise the --environment option given to the server won't propagate.
        require 'ecrire'
        Dir.chdir(Ecrire::Application.root)
        server.start
      end
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
      Rails::Console.start(Ecrire::Application, options)
    end

    def update
      puts "Updating ecrire for your blog"
      require 'ecrire'
      begin
        initialize_application!
        migrate!
        puts "Your blog has successfully been updated with the latest version #{Ecrire::VERSION}"
      rescue Exception => exception
        puts "An error occurred while updating: #{exception.message}"
        puts exception.backtrace
      end
    end

    def new
      require 'fileutils'
      project_name = ARGV.shift
      if project_name.nil?
        raise 'You need to specify a name for your new blog'
      end
      project_folder = "#{Dir.pwd}/#{project_name}"
      Dir.mkdir project_folder
      Dir.chdir project_folder
      template = File.expand_path '../themes/template/*', __FILE__
      FileUtils.cp_r(Dir[template], project_folder)
    end

    def version
      puts "Ecrire #{Ecrire::VERSION}"
    end

    def initialize_application!
      require 'ecrire'
      Ecrire::Application.initialize!
    end

    def migrate!
      retried = 0
      puts 'Migrating database...'
      ActiveRecord::Tasks::DatabaseTasks.database_configuration = ActiveRecord::Base.configurations
      ActiveRecord::Migrator.migrations_paths = ActiveRecord::Tasks::DatabaseTasks.migrations_paths
      ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
      begin
        ActiveRecord::Migrator.migrate(ActiveRecord::Migrator.migrations_paths, ENV["VERSION"] ? ENV["VERSION"].to_i : nil) do |migration|
          ENV["SCOPE"].blank? || (ENV["SCOPE"] == migration.scope)
        end
      rescue ActiveRecord::NoDatabaseError => e
        if retried == 0
          retried += 1
          puts 'Database does not exist. Creating...'
          ActiveRecord::Tasks::DatabaseTasks.create_current
          puts 'Database created, migrating now...'
          retry
        else
          raise e
        end
      end
      puts 'Migration completed.'
    end

  end
end
