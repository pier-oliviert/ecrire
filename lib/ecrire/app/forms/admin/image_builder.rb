module Admin
  class ImageBuilder < ActionView::Helpers::FormBuilder

    def message
      if object.header?
        [
          content_tag(:p, "You can replace your header by either <strong>clicking</strong> or <strong>dropping</strong> a picture here.".html_safe),
          remove_header_button
        ].join.html_safe
      else
        content_tag :p, "Upload a picture for your post' header by either <strong>clicking</strong> or <strong>dropping</strong> a picture here".html_safe
      end
    end

    def remove_header_button
      button_to "",
        admin_post_properties_path(object.id),
        method: :delete,
        params: {
          property: 'image'
        },
        data: {confirm: 'Are you sure you want to destroy this image?'}
    end

    protected

    def t(*args)
      args.push({}) unless args.last.is_a?(Hash)
      args.last[:scope] = %w(admin form image)
      I18n.t *args
    end

    def method_missing(method, *args, &block)
      @template.send(method, *args, &block)
    end
  end
end
