module Onboarding
  class DatabasesController < OnboardingController

    def create
      begin
        ActiveRecord::Base.configurations = {
          'development' => db_params,
          'production' => db_params
        }
        ActiveRecord::Base.establish_connection
        ActiveRecord::Base.connection
        save_configurations!
      rescue Exception => e
        @exception = e
        ActiveRecord::Base.clear_all_connections!
        render 'index' and return
      end
      redirect_to onboarding_users_path
    end

    private

    def db_params
      @db_params ||= {
        'adapter' => 'postgresql',
        'database' => params[:database]['name'],
        'password' => params[:database]['password'],
        'encoding' => 'utf8'
      }
    end

    def save_configurations!
      File.open(Dir.pwd + '/config/database.yml', 'w') do |file|
        file.write(ActiveRecord::Base.configurations.to_yaml)
      end
    end

  end
end
