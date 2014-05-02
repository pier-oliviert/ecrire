class Admin::ImageBuilder < ActionView::Helpers::FormBuilder
  def drop_pad
    content_tag :div, id: "imageDropPad" do
      content_tag :span, t('drop_pad'), class: %w(message)
    end
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
