module Admin
  class PostBuilder < ActionView::Helpers::FormBuilder

    def initialize(object_name, object, template, options)
      if object.draft?
        options[:html][:class] << 'autosave'
      end
      super
    end

    def errors
      return unless object.errors.any?
      content_tag :div, class: %w(container errors) do
        [
          content_tag(:span, h(object.errors.full_messages.to_sentence)),
          link_to("x", "javascript:void(0)", class: %w(dismiss button))
        ].join.html_safe
      end
    end

    def editor
      content_tag :section, class: %w(textareas) do
        [
          text_area(:content, placeholder: t('.content'), class: %w(content active), target: 'content'),
          text_area(:stylesheet, placeholder: t('.stylesheet'), class: %w(stylesheet), target: 'stylesheet'),
          text_area(:javascript, placeholder: t('.javascript'), class: %w(javascript), target: 'javascript')
        ].join.html_safe
      end
    end

    def action
      if object.published?
        button 'Save', value: 'save', form: "postEditor"
      else
        button 'Publish', value: 'publish', form: "postEditor"
      end
    end

    def t(*args)
      I18n.t args[0], scope: %w(admin form post)
    end

    def method_missing(method, *args, &block)
      @template.send(method, *args, &block)
    end
  end
end
