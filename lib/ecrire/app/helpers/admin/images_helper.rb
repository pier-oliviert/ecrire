module Admin
  module ImagesHelper

    def image_form_signature(policy)
      @signature ||= begin
        key = Rails.application.secrets.s3['secret_key']
        sha = OpenSSL::Digest.new('sha1')
        digest = OpenSSL::HMAC.digest sha, key, policy
        Base64.encode64(digest).gsub("\n", "")
      end
    end

    def image_form_policy(post)
      @policy ||= begin
                    policy = {
                      "expiration" => "2019-01-01T00:00:00Z",
                      "conditions" => [
                        {"bucket" => "ecrire_test"},
                        ["starts-with", "$key", "#{post.id}/"],
                        {"acl" => "private"},
                        {'success_action_status' => '201'}
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
