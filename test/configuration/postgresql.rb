class Ecrire::Test::Configuration::Postgresql
  class PSQLError < Ecrire::Test::Configuration::Error; end;
  require_relative 'postgresql/user'

  attr_reader :user

  def initialize(app)
    @app = app
  end

  def configure!
    begin
      unless configured?
        puts "It seems you are running the development tests for the first time."
        puts "Ecrire will try to configure postgresql for you..."

        if user.new?
          create_user!
        end

        if !user.superuser?
          user.superuser!
        end

        if !user.login?
          user.login!
        end

        puts "Done configuring postgresql."
      end

    rescue Ecrire::Test::Configuration::Error => e
      puts "Ecrire couldn't configure postgresql."
      puts "=> #{e.message}"
      puts "To fix this issue, make sure you have a superuser for #{%x(whoami)}"
      puts "createuser -l -s postgres"
      exit
    end
  end

  def configured?
    %x(psql -c '' -d #{database} -U #{user.name} 2>&1)
    if $?.to_i != 0
      return false
    end
    return true
  end

  def migrate!
    path = @app.paths['db/migrate'].existent
    ActiveRecord::Migrator.migrations_paths = path
    if ActiveRecord::Migrator.needs_migration?
      ActiveRecord::Migration.verbose = false
      ActiveRecord::Migrator.migrate(path)
    end
    ActiveRecord::Migration.maintain_test_schema!
    ActiveRecord::Base.clear_cache!
  end

  def create_user!
    puts "Creating user #{user.name}..."
    message = %x(psql -c 'CREATE ROLE #{user.name} with superuser login' -d postgres -U postgres 2>&1)
    if $?.to_i != 0
      raise PSQLError.new message
    end
    puts "User #{user.name} created."
  end

  def reset_database!(silence = false)
    unless silence
      puts "Resetting #{database} if it exists..."
    end

    ActiveRecord::Tasks::DatabaseTasks.drop({'adapter' => 'postgresql', 'database' => database, 'user' => user.name})
    ActiveRecord::Tasks::DatabaseTasks.create({'adapter' => 'postgresql', 'database' => database, 'user' => user.name})

    migrate!

    unless silence
      puts "#{@database} configured."
    end
  end

  def user
    @user ||= User.new(@app.secrets.database[:username])
  end

  def database
    @database ||= @app.secrets.database[:database]
  end

end
