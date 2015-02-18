module Property
  class Label
    attr_accessor :post

    def name
      "label"
    end

    def create(params)
      new_label = ::Label.find_or_create_by!(name: params[:value])
      labels = post.labels
      labels << new_label
      post.labels = labels
      post.save!
      new_label
    end

    def destroy(params)
      label = ::Label.find_by!(name: params[:value])
      labels = post.labels
      labels.delete(label)
      post.labels = labels
      post.save!
      label
    end

  end
end
