module Admin
  class Image < ::Image
    def self.service
      @service ||= S3::Service.new(access_key_id: Rails.application.s3.access_key,
                                   secret_access_key: Rails.application.s3.secret_key)
    end

    def self.bucket
      service.bucket('marmite')
    end
  end
end
