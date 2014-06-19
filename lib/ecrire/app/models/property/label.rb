module Property
  class Label
    attr_accessor :post

    def name
      "label"
    end

    def create(value)
      label = Admin::Label.find_or_create_by!(name: value)
      ids = label_ids
      ids << label.id.to_s
      post.label_ids = ids.uniq.join(',')
      post.save!
      label
    end

    def destroy(value)
      label = Admin::Label.find_by!(name: value)
      ids = label_ids
      ids.delete(label.id.to_s)
      post.label_ids = ids.uniq.join(',')
      post.save!
      label
    end

    def label_ids
      post.label_ids.split(',')
    end
  end
end
