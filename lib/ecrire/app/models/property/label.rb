module Property
  class Label
    attr_accessor :post

    def name
      "label"
    end

    def create(value)
      new_label = ::Label.find_or_create_by!(name: value)
      labels = post.labels
      labels << new_label
      post.labels = labels
      post.save!
      new_label
    end

    def destroy(value)
      label = ::Label.find_by!(name: value)
      labels = post.labels
      labels.delete(label)
      post.labels = labels
      post.save!
      label
    end

    def label_ids
      post.label_ids.split(',')
    end
  end
end
