module Admin
  class PostBuilder < ActionView::Helpers::FormBuilder

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
      [
        editor_options,
        content_tag(:div, class: %w(main editor)) do
          [
            editor_content,
            content_tag(:div, preview, id: "editorSideContent")
          ].join.html_safe
        end
      ].join.html_safe
    end

    def title
      content_tag :div, id: "post_title_wrapper", class: %w(title wrapper) do
        [
          text_field(:title, placeholder: t('.title'), class: %w(input)),
          content_tag(:a, nil, class: %w(toggle entypo-link)),
          text_field(:slug, placeholder: t('.slug'), class: %w(input hidden)),
          possible_actions
        ].join.html_safe
      end
    end

    protected

    def preview
      content_tag(:article, class: %w(content preview)) do
        [
          content_tag(:style),
          content_tag(:script, nil, class: %w(preview), type: 'text/javascript'),
          content_tag(:article, nil, class: %w(preview content)),
        ].join.html_safe
      end
    end

    def editor_options
      content_tag :div, class: %w(wrapper editor options) do
        Options.new(@template, object).render
      end
    end

    def editor_content
      content_tag :div, class: %w(content wrapper) do
        [
          text_area(:content, placeholder: t('.content'), class: %w(content editor)),
          text_area(:stylesheet, placeholder: t('.stylesheet'), class: %w(stylesheet hidden editor)),
          text_area(:javascript, placeholder: t('.javascript'), class: %w(javascript hidden editor))
        ].join.html_safe
      end
    end

    def possible_actions
      content_tag :div, class: %w(possible save actions) do
        if object.draft?
          [
            content_tag(:div, class: %w(wrapper)) do
              [
                save_button,
                publish_button
              ].join.html_safe
            end,
            content_tag(:span, '&#59228;'.html_safe, class: %w(arrow))
          ].join.html_safe
        else
          content_tag(:div, save_button, class: %w(wrapper standalone))
        end
      end
    end

    def save_button
      button("Save", name: "admin_post[status]", value: "draft", class: %w(button))
    end

    def publish_button
      button("Publish", name: "admin_post[status]", value: "publish", class: %w(button hidden))
    end

    def t(*args)
      I18n.t args[0], scope: %w(admin form post)
    end

    def method_missing(method, *args, &block)
      @template.send(method, *args, &block)
    end

    class Options

      def initialize(template, object)
        @template = template
        @object = object
      end

      def render
        [
          content_tag(:div, editor_options, class: %w(editor options)),
          content_tag(:div, preview_options, class: %w(preview options))
        ].join.html_safe
      end

      def editor_options
        [
          content_tag(:a, t('fields.text'), binding: ".editor.content", class: %w(content active)),
          content_tag(:a, t('fields.CSS'), binding: ".editor.stylesheet", class: %w(content)),
          content_tag(:a, t('fields.JS'), binding: ".editor.javascript", class: %w(content))
        ].join.html_safe
      end

      def preview_options
        options = [
          link_to(t('preview'), 'javascript:void(0)', class: %w(active), id: "previewLink"),
          link_to(t('partials'), admin_partials_path(), id: "partialsListLink", remote: true)
        ]

        if @object.persisted?
          options << link_to(t('images.link'), admin_post_images_path(@object), id: "imagesListLink", remote: true)
        else
          options << content_tag(:span, t('images.post_not_persisted'), class: %w(disabled))
        end

        options.join.html_safe
      end

      def t(*args)
        I18n.t args[0], scope: %w(admin form post options)
      end

      def method_missing(method, *args, &block)
        @template.send(method, *args, &block)
      end
    end

  end
end
