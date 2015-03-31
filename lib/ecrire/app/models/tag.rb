class Tag < ActiveRecord::Base
  def ==(other)
    self.class.table_name == other.class.table_name && self.id == other.id
  end

  def posts
    post_scope = ->(tag) { where '? = ANY (posts.tags)', tag.id }
    options = {}
    reflection = ActiveRecord::Reflection::HasManyReflection.new(:posts, post_scope, options, self.class)
    association = PostsAssociation.new(self, reflection)
    @posts ||= ActiveRecord::Associations::CollectionProxy.new(Post, association)
  end

  private

  class PostsAssociation < ActiveRecord::Associations::HasManyAssociation
    def scope(opts = {})
      Post.where('? = ANY (posts.tags)', owner.id).published.order('published_at DESC')
    end
  end

end
