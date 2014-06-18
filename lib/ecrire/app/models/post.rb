require 'nokogiri'

class Post < ActiveRecord::Base
  has_many :images
  has_many :properties

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
  before_save :generate_excerpt

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
      id
    else
      slug
    end
  end

  def title=(new_title)
    super
    if self.draft?
      self.slug = nil
    end
  end

  protected

  def create_slug_if_nil
    return unless self.slug.blank?
    self.slug = self.title.parameterize
  end

  def generate_excerpt
    html = Nokogiri::HTML(self.content).xpath("//body").children
    self.excerpt = html.children.to_a.join(" ")[0..75] << "..."
  end
end
