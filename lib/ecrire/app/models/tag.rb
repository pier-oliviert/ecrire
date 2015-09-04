class Tag < ActiveRecord::Base
  class Validator < ActiveModel::Validator
    def validate(record)
      validate_presence! record
      validate_uniqueness! record
    end

    def validate_presence!(record)
      if record.name.blank?
        msg = "Your tag can't be blank."
        record.errors['name'] << msg
      elsif record.name.length < 1
        msg = "Your tag needs to be at least 1 character long."
        record.errors['name'] << msg
      end
    end

    def validate_uniqueness!(record)
      tag = Tag.where('tags.name = ?', record.name).first
      unless tag.nil?
        msg = "You already have a tag with this name: #{tag.name}"
        record.errors['uniqueness'] << msg
        return
      end
    end
  end

  include PgSearch
  include ActiveModel::Validations
  validates_with Tag::Validator

  pg_search_scope :search_by_name,
    against: :name,
    :using => {
      :tsearch => {:prefix => true}
    }


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
