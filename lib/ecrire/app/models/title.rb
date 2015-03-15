class Title < ActiveRecord::Base
  class Validator < ActiveModel::Validator
    def validate(record)
      validate_length! record
      validate_uniqueness! record
    end

    def validate_length!(record)
      if record.name.blank?
        record.errors['name'] << "Your title can't be blank."
      elsif record.name.length < 1
        record.errors['name'] << "Your title needs to be at least 1 character long."
      end
    end

    def validate_uniqueness!(record)
      title = Title.slug(record.slug).first
      unless title.nil?
        record.errors['slug'] << "You already have a post with this name: #{title.name}"
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

  protected

  def generate_slug
    self.slug = self.name.parameterize
  end

end
