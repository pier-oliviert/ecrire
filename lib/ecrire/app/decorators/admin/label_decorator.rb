module Admin
  class LabelDecorator < EcrireDecorator
    def button(options)
      post = options[:post]
      if post.labels.map(&:id).include?(record.id)
        destroy(post: post)
      else
        create(post: post)
      end
    end

    def create(options)
      button_to record.name.capitalize,
        admin_post_properties_path(options[:post].id),
        remote: true,
        form: {id: "label-#{record.id}"},
        form_class: %w(create label),
        params: {
          property: :label,
          value: record.name
        }
    end

    def destroy(options)
      button_to record.name.capitalize,
        admin_post_properties_path(options[:post].id),
        form: {id: "label-#{record.id}"},
        form_class: %w(destroy label),
        method: :delete,
        remote: true,
        params: {
          property: :label,
          value: record.name
        }
    end

  end
end
