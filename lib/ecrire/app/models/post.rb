require 'nokogiri'

class Post < ActiveRecord::Base
  has_one :header, class_name: Image

  store_accessor :properties, :labels

  scope :status, lambda {|status|
    if status.eql?("published")
      where "posts.published_at IS NOT NULL"
    else
      where "posts.published_at IS NULL"
    end
  }

  scope :published, lambda { status("published") }
  scope :drafted, lambda { status("drafted") }
  scope :slug, lambda { |slug| where("posts.slug is ?", slug) }
  scope :without, lambda { |post| where("posts.id != ?", post.id) }

  validates :title, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true

  before_validation :create_slug_if_nil

  def status=(new_status)
    if new_status.eql? "publish"
      publish!
    end
  end

  def publish!
    return unless published_at.nil?
    self.published_at = DateTime.now
    save!
  end

  def published?
    !draft?
  end

  def draft?
    published_at.nil?
  end

  def to_param
    if self.instance_of?(Admin::Post)
      id.to_s
    else
      slug
    end
  end

  def content
    (self.compiled_content || super || '').html_safe
  end

  def excerpt
    (self.compiled_excerpt || "").html_safe
  end


  def title=(new_title)
    super
    if self.draft?
      self.slug = nil
    end
  end

  def header?
    !self.header.nil? && !self.header.url.blank?
  end

  def labels
    ids = super || ''
    Label.where(id: ids.split(',')).to_a
  end

  def labels=(labels)
    super(labels.map(&:id).join(','))
  end

  protected

  def create_slug_if_nil
    return unless self.slug.blank?
    self.slug = self.title.parameterize
  end

end
