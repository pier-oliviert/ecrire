class Admin::Configurations::ImagesController < Admin::ApplicationController

  def show
    @s3 = Admin::Image::S3.new
  end

  def create
    @s3 = Admin::Image::S3.new params[:s3]
    @s3.connect
    if @s3.errors.any?
      render 'show' and return
    else
      save_configurations!
      render 'complete'
    end
  end

  protected

  def save_configurations!
    path = Rails.application.paths['config/secrets'].expanded.first
    secrets = YAML.load_file(path)
    Rails.application.secrets.s3 = secrets['defaults']['s3'] = secrets['development']['s3'] = secrets['production']['s3'] = @s3.configuration_hash
    File.open(path, 'w') do |file|
      file.write(secrets.to_yaml)
    end
  end
end
