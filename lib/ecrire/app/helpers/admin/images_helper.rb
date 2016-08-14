module Admin
  module ImagesHelper

    def image_form_signature(policy)
      @signature ||= begin
        key = Rails.application.secrets.s3[:secret_key]
        sha = OpenSSL::Digest.new('sha1')
        digest = OpenSSL::HMAC.digest sha, key, policy
        Base64.encode64(digest).gsub("\n", "")
      end
    end

    def image_form_policy(post)
      @policy ||= begin
                    namespace = [post.id]
                    if Rails.application.secrets.s3.has_key?(:namespace)
                      namespace.insert 0, Rails.application.secrets.s3[:namespace]
                    end

                    policy = {
                      "expiration" => (Time.now + 10.years).utc.to_s(:iso8601),
                      "conditions" => [
                        {"bucket" => Rails.application.secrets.s3[:bucket]},
                        ["starts-with", "$key", "#{namespace.join('/')}/"],
                        ["starts-with", "$Content-Type", ""],
                        {"acl" => "private"}
                      ]
                    }
                    Base64.encode64(policy.to_json).gsub("\n","")
      end
    end

    def editor_image_tag(post)
      return unless post.header?
      content_tag :div, class: %w(image), style: "background-image: url('#{post.header.url}')" do
        button_to "Remove this image",
          admin_post_properties_path(post.id),
          method: :delete,
          remote: true,
          params: {
            property: 'image'
          },
          data: {confirm: 'Are you sure you want to destroy this image?'}
      end
    end

    def images_config_title
      if @s3 && @s3.errors.any?
        content_tag :h1, class: %w(error) do
          @s3.errors.messages.values.flatten.to_sentence
        end
      else
        content_tag :h1 do
          t('admin.images.helper.title')
        end
      end
    end
  end
end
