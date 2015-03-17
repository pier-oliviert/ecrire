class Title < ActiveRecord::Base
  class Validator < ActiveModel::Validator
    def validate(record)
      validate_length! record
      validate_uniqueness! record
      validate_draft! record
    end

    def validate_length!(record)
      if record.name.blank?
        record.errors['name'] << "Your title can't be blank."
      elsif record.name.length < 1
        record.errors['name'] << "Your title needs to be at least 1 character long."
      end
    end

    def validate_uniqueness!(record)
      title = Title.where('titles.slug = ? OR titles.name = ?', record.slug, record.name).first
      unless title.nil?
        record.errors['uniqueness'] << "You already have a post with this title: #{title.name}"
        return
      end
    end

    def validate_draft!(record)
      if record.post.published? && !record.new_record?
        record.errors['post'] << "You cannot modify an existing title when a post is published"
      end
    end

  end

  include ActiveModel::Validations
  validates_with Title::Validator

  before_validation :generate_slug

  belongs_to :post, required: true

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
