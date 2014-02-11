require 's3'

module Admin
  class Image < ::Image
    belongs_to :post, class_name: Admin::Post
    before_create :upload_file
    before_destroy :remove_file

    def file=(file)
      @file = Admin::Image.bucket.objects.build path(file)
      @file.content = file
    end

    protected

    def upload_file
      @file.save unless @file.nil?
      self.url = @file.url
      self.key = @file.key
    end

    def remove_file
      s3.destroy
    end

    def path(file)
      items = [post.id, file.original_filename]
      unless (base_folder = Rails.configuration.s3.base_folder).blank?
        items.prepend base_folder
      end

      items.join("/")
    end

    private

    def s3
      Admin::Image.bucket.object(self.key)
    end

    def self.service
      @service ||= S3::Service.new(access_key_id: Rails.configuration.s3.access_key,
                                   secret_access_key: Rails.configuration.s3.secret_key,
                                   use_ssl: true
                                  )
    end

    def self.bucket
      self.service.bucket(Rails.application.config.s3.bucket)
    end

  end
end

