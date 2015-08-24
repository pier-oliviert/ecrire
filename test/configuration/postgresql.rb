class Ecrire::Test::Configuration::Postgresql
  class PSQLError < Ecrire::Test::Configuration::Error; end;
  require_relative 'postgresql/user'

  attr_reader :user

  def initialize(database, user)
    @database = database
    @user = User.new(user)
  end

  def configured?
    %x(psql -c '' -d #{@database} -U #{@user.name} 2>&1)
    if $?.to_i != 0
      return false
    end
    return true
  end

  def create_user!
    puts "Creating user #{@user.name}..."
    message = %x(psql -c 'CREATE ROLE #{@user.name} with superuser login' -d postgres -U postgres 2>&1)
    if $?.to_i != 0
      raise PSQLError.new message
    end
    @user= User.new(@user.name)
    puts "User #{@user.name} created."
  end

  def reset_database!(silence = false)
    unless silence
      puts "Resetting #{@database} if it exists..."
    end

    ActiveRecord::Tasks::DatabaseTasks.drop({'adapter' => 'postgresql', 'database' => @database, 'user' => user.name})
    ActiveRecord::Tasks::DatabaseTasks.create({'adapter' => 'postgresql', 'database' => @database, 'user' => user.name})

    unless silence
      puts "#{@database} configured."
    end
  end

end
