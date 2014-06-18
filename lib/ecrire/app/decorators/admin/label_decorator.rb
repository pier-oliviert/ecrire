module Admin
  class LabelDecorator < EcrireDecorator
    def button(options)
      post = options[:post]
      properties = options[:properties].select do |property|
        property.data.id == record.id
      end
      
      if properties.any?
        properties.map do |property|
          destroy(property: property)
        end.join.html_safe
      else
        create(post: post)
      end
    end

    def create(options)
      button_to record.name,
        admin_post_properties_path(options[:post].id),
        remote: true,
        form: {id: "label-#{record.id}"},
        form_class: %w(create label),
        params: {
          label_id: record.id
        }
    end

    def destroy(options)
      button_to record.name,
        admin_property_path(options[:property]),
        form: {id: "label-#{record.id}"},
        form_class: %w(destroy label),
        method: :delete,
        remote: true
    end

  end
end
