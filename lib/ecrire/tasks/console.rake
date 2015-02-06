desc 'Load the console'

namespace :rails do
  task :console do |task, args|
    require 'rails/commands/console'

    shift_argv!
    Rails.application.require_environment!
    Ecrire::Application.initialize!

    Rails::Console.start(Ecrire::Application, args)
  end

  def shift_argv!
    ARGV.shift if ARGV.first && ARGV.first[0] != '-'
  end

end
