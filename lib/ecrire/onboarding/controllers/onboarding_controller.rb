class OnboardingController < ApplicationController

  def index
    if File.exist?(Rails.application.paths['config/secrets'].expanded.last)
      render 'complete' and return
    end
    render 'welcome'
  end

  protected

  def save_configurations!
    File.open(Rails.application.paths['config/secrets'].expanded.last, 'w') do |file|
      config = ActiveRecord::Base.configurations
      config['development'] ||= {}
      config['production'] ||= {}
      config['development']['secret_key_base'] = config['production']['secret_key'] = Rails.application.secrets.secret_key_base
      file.write(config.to_yaml)
    end
  end

end

