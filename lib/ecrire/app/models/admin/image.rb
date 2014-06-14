require 's3'

module Admin
  class Image < ::Image
    belongs_to :post, class_name: Admin::Post
    before_create :upload_file
    before_destroy :remove_file

    attr_accessor :s3

    def s3
      @s3 ||= S3.new(Rails.application.secrets.s3 || {})
    end

    def file=(file)
      @file = s3.bucket.objects.build path(file)
      @file.content = file
    end


    protected

    def upload_file
      @file.save unless @file.nil?
      self.url = @file.url
      self.key = @file.key
    end

    def remove_file
    end

    def path(file)
      items = [post.id, file.original_filename]

      items.prepend(s3.path) unless s3.path.blank?

      items.join("/")
    end

    class S3
      include ::S3

      attr_reader :bucket, :access_key, :secret_key, :path, :errors
      
      def initialize(options={})
        @errors = ActiveModel::Errors.new(self)
        @access_key = options.fetch('access_key', "")
        @secret_key = options.fetch('secret_key', "")
        @path = options.fetch('path', "")

        @bucket = service.bucket(options.fetch('bucket', 'ecrire'))
      end

      def configuration_hash
        config = {
          'access_key' => access_key,
          'secret_key' => secret_key,
          'bucket' => bucket.name
        }

        unless path.blank?
          config['path'] = path
        end

        config
      end

      def connect
        begin
          @bucket.retrieve
          @connected = true
        rescue Error::ResponseError, ArgumentError => e
          errors.add :remote, e
        end
      end

      def service
        @service ||= Service.new(access_key_id: access_key,
                               secret_access_key: secret_key,
                               use_ssl: true
                              )
      end

      def connected?
        if @connected.nil?
          connect
        end
        !!@connected
      end

    end
  end
end
