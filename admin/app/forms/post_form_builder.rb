class PostFormBuilder < ActionView::Helpers::FormBuilder
  def header
    content_tag :section, id: "postAndBlogActions" do
      [
        link_to("Admin", :root),
        flash_container,
        content_tag(:div, class: %w(actions overlay)) do
          possible_actions
        end
      ].join.html_safe
    end
  end

  def editor
    [
      editor_options,
      editor_wrapper do
        [
          text_area(:content, placeholder: t('.content'), class: %w(editor)),
          text_area(:stylesheet, placeholder: t('.stylesheet'), class: %w(hidden editor)),
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
        text_field(:slug, placeholder: t('.slug'), class: %w(hidden))
      ].join.html_safe
    end
  end

  def preview
    content_tag(:div, id: "content_preview") do
      [
        content_tag(:span, t('.preview'), class: %w(sticky)),
        content_tag(:style),
        content_tag(:div, nil, class: %w(preview)),
      ].join.html_safe
    end
  end

  def method_missing(method, *args, &block)
    @template.send(method, *args, &block)
  end

  protected

  def editor_options
    content_tag :div, id: "post_editing_options" do
      content_tag :div, class: %w(wrapper) do
        [
          content_tag(:a, t('.text'), binding: "post_content", class: %w(active)),
          content_tag(:a, t('.CSS'), binding: "post_stylesheet")
        ].join.html_safe
      end
    end
  end

  def editor_wrapper
    content_tag :div, class: %w(height spacing) do
      content_tag :div, class: %w(wrapper) do
        yield if block_given?
      end
    end
  end

  def flash_container
    content_tag :div, nil, id: "flashMessage"
  end

  def possible_actions
    buttons = [
      button("Save", name: "post[status]", value: "draft"),
    ]

    if object.draft?
      buttons << button("Publish", name: "post[status]", value: "publish")
    end

    buttons.join.html_safe
  end

end
