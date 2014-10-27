module Admin::LabelsHelper
  def create_label_button(label, post)
    button_to label.name.capitalize,
      admin_post_properties_path(post.id),
      remote: true,
      form: {id: "label-#{label.id}"},
    form_class: %w(create label),
      params: {
      property: :label,
      value: label.name
    }
  end

  def destroy_label_button(label, post)
    button_to label.name.capitalize,
      admin_post_properties_path(post.id),
      form: {id: "label-#{label.id}"},
    form_class: %w(destroy label),
      method: :delete,
      remote: true,
      params: {
        property: :label,
        value: label.name
      }
  end
end
