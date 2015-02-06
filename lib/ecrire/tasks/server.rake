desc 'Start the server'

namespace :rails do

  task :server do |task, args|
    require 'rails/commands/server'

    shift_argv!
    Rails::Server.new.tap do |server|
      Dir.chdir(Rails.application.root)
      server.start
    end
  end

  def shift_argv!
    ARGV.shift if ARGV.first && ARGV.first[0] != '-'
  end

end

