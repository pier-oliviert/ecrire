class Title < ActiveRecord::Base
  class Validator < ActiveModel::Validator
    def validate(record)
      validate_length! record
      validate_uniqueness! record
      validate_draft! record
    end

    def validate_length!(record)
      if record.name.blank?
        msg = "Your title can't be blank."
        record.errors['name'] << msg
        record.post.errors['title'] << msg
      elsif record.name.length < 1
        msg = "Your title needs to be at least 1 character long."
        record.errors['name'] << msg
        record.post.errors['title'] << msg
      end
    end

    def validate_uniqueness!(record)
      title = Title.where('titles.slug = ? OR titles.name = ?', record.slug, record.name).first
      unless title.nil?
        msg = "You already have a post with this title: #{title.name}"
        record.errors['uniqueness'] << msg
        record.post.errors['title'] << msg
        return
      end
    end

    def validate_draft!(record)
      if record.post.published? && !record.new_record?
        msg = "You cannot modify an existing title when a post is published"
        record.errors['draft'] << msg
        record.post.errors['title'] << msg
      end
    end

  end

  include PgSearch
  include ActiveModel::Validations
  validates_with Title::Validator

  before_validation :generate_slug

  belongs_to :post, required: true

  pg_search_scope :search_by_name,
    against: :name,
    :using => {
      :tsearch => {:prefix => true}
    }

  scope :slug, lambda { |slug|
    where('titles.slug = ?', slug)
  }

  def name=(new_name)
    super new_name.strip
  end

  protected

  def generate_slug
    self.slug = self.name.parameterize.downcase
  end

end
