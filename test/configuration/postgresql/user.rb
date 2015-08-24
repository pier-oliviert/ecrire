class Ecrire::Test::Configuration::Postgresql::User
  attr_reader :name

  def initialize(name)
    @name = name
    output = %x(psql -c "select rolname, rolsuper, rolcanlogin from pg_roles where rolname = '#{name}';" -U postgres -d postgres -t -A 2>&1)

    if $?.to_i != 0 || output.blank?
      @exists = false
      return
    end

    @exists = true
    row = output.chomp.split('|')

    @name = row[0]
    @superuser = row[1] == 't'
    @login = row[2] == 't'
  end

  def new?
    !@exists
  end

  def superuser?
    @superuser
  end

  def login?
    @login
  end

  def superuser!
    puts "Making #{@name} a superuser..."
    message = %x(psql -c "alter role #{@name} with superuser" -U postgres -d postgres 2>&1)
    if $?.to_i != 0
      raise Ecrire::Test::Configuration::Postgresql::PSQLError.new message
    end
    puts "#{@name} is a superuser."
  end

  def login!
    puts "Making #{@name} loggable..."
    message = %x(psql -c "alter role #{@name} with login" -U postgres -d postgres 2>&1)
    if $?.to_i != 0
      raise Ecrire::Test::Configuration::Postgresql::PSQLError.new message
    end
    puts "#{@name} can log in."
  end
end
