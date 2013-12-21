module Admin
  class PostBuilder < ActionView::Helpers::FormBuilder
    def header
      content_tag :section, id: "postAndBlogActions" do
        [
          link_to("Admin", :root),
          flash_container
        ].join.html_safe
      end
    end

    def editor
      [
        editor_options,
        content_tag(:div, class: %w(main editor)) do
          [
            editor_content,
            preview
          ].join.html_safe
        end
      ].join.html_safe
    end

    def title
      content_tag :div, id: "post_title_wrapper" do
        [
          text_field(:title, placeholder: t('.title')),
          content_tag(:a, nil, class: %w(toggle entypo-link)),
          text_field(:slug, placeholder: t('.slug'), class: %w(hidden)),
          possible_actions
        ].join.html_safe
      end
    end

    protected

    def preview
      content_tag(:div, class: %w(content preview)) do
        [
          content_tag(:span, t('.preview'), class: %w(sticky)),
          content_tag(:style),
          content_tag(:script, nil, class: %w(preview), type: 'text/javascript'),
          content_tag(:div, nil, class: %w(preview)),
        ].join.html_safe
      end
    end

    def editor_options
      content_tag :div, id: "post_editing_options" do
        Options.new(@template).render
      end
    end

    def editor_content
      content_tag :div, class: %w(content wrapper) do
        [
          text_area(:content, placeholder: t('.content'), class: %w(editor)),
          text_area(:stylesheet, placeholder: t('.stylesheet'), class: %w(hidden editor))
        ].join.html_safe
      end
    end

    def editor_wrapper
      content_tag :div, class: %w(wrapper) do
        yield if block_given?
      end
    end

    def flash_container
      return if object.errors.blank?
      content_tag :div, object.errors.full_messages.to_sentence, id: "formErrors", class: %w(flash) do
        content_tag :div, class: %w(wrapper) do
          [
            object.errors.full_messages.to_sentence,
            link_to("x", "javascript:void(0)", class: %w(dismiss button))
          ].join.html_safe
        end
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
      button("Save", name: "post[status]", value: "draft", class: %w(button))
    end

    def publish_button
      button("Publish", name: "post[status]", value: "publish", class: %w(button hidden))
    end

    def method_missing(method, *args, &block)
      @template.send(method, *args, &block)
    end

    class Options

      def initialize(template)
        @template = template
      end

      def render
        [
          content_tag(:div, editor_options, class: %w(editor options)),
          content_tag(:div, preview_options, class: %w(preview options))
        ].join.html_safe
      end

      def editor_options
        [
          content_tag(:a, t('.text'), binding: "post_content", class: %w(content active)),
          content_tag(:a, t('.CSS'), binding: "post_stylesheet", class: %w(content)),
          content_tag(:a, t('.JS'), binding: "post_javascript", class: %w(content))
        ].join.html_safe
      end

      def preview_options
        [
          content_tag(:a, t('.preview'), class: %w(active)),
          content_tag(:a, t('.AB')),
          content_tag(:a, t('.partials'))
        ].join.html_safe
      end

      def method_missing(method, *args, &block)
        @template.send(method, *args, &block)
      end
    end

  end
end
