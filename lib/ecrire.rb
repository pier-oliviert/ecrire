require 'rails'

module Ecrire

  autoload :Application,        'ecrire/application'


  def self.bundle?
    ENV['BUNDLE_GEMFILE'] ||= Dir.pwd + '/Gemfile'
    File.exists?(ENV['BUNDLE_GEMFILE'])
  end

  require 'bundler/setup' if Ecrire.bundle?

end

