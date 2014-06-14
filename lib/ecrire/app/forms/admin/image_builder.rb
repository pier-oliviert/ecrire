module Admin
  class ImageBuilder < ActionView::Helpers::FormBuilder

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
