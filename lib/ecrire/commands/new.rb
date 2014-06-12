require 'yaml'
require 'securerandom'
require 'bundler'

module Ecrire
  class New

    def self.generate!(name)
      new(name).generate!
    end

    def initialize(name)
      @name = name
    end

    def generate!
      copy_template!
      generate_secrets!
      bundle!
    end

    def copy_template!
      require 'fileutils'
      path = "#{Dir.pwd}/#{@name}"
      Dir.mkdir @name
      Dir.chdir @name
      template = File.expand_path '../../template/*', __FILE__
      FileUtils.cp_r(Dir[template], path)
    end

    def generate_secrets!
      File.open(Dir.pwd + '/secrets.yml', 'w') do |file|
        secrets = Hash.new
        secrets['production'] = secrets['development'] = secrets['defaults'] = Hash.new
        secrets['defaults']['secret_key_base'] = SecureRandom.hex(64)
        file.write(secrets.to_yaml)
      end
    end

    def bundle!
      require 'bundler/cli'
      Bundler::CLI.new.install
    end

  end
end
