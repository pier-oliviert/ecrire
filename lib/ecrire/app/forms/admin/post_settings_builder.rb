module Admin
  class PostSettingsBuilder < ActionView::Helpers::FormBuilder
    def initialize(object_name, object, template, options)
      if object.draft?
        options[:html][:class] << 'autosave'
      end
      super
    end

    def notice
      if object.draft?
        content_tag :p, t('admin.posts.permalink.editable')
      else
        content_tag :p, t('admin.posts.permalink.permanent')
      end
    end

    def permalink
      content_tag :p, post_path(object.becomes(::Post), only_path: false), class: %w(url)
    end

    def actions
      content_tag :div, class: %w(actions) do
        body = [
          content_tag(:span),
          button_tag('Close', class: %w(close))
        ]

        if object.published?
          body.insert 1, button_tag('Save', class: %w(save))
        end

        body.join.html_safe
      end
    end

    def method_missing(method, *args, &block)
      @template.send(method, *args, &block)
    end
  end
end
