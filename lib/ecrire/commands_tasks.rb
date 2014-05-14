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
      require_command!("server")

      server = Ecrire::Server.new.tap do |server|
        # We need to require application after the server sets environment,
        # otherwise the --environment option given to the server won't propagate.
        require 'ecrire'
        Dir.chdir(Ecrire::Application.root)
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
      Ecrire::Console.start(Ecrire::Application, options)
    end

    def update
      puts "Updating ecrire for your blog"
      require 'ecrire'
      begin
        initialize_application!
        require_command!('migrate')

        Ecrire::Migrate.new.run!
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

    def require_command!(command)
      require "ecrire/commands/#{command}"
    end

  end
end
