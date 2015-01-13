require 'nokogiri'

class Post < ActiveRecord::Base
  has_many :images

  store_accessor :properties, :labels, :header

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
      id.to_s
    else
      slug
    end
  end

  def content
    (self.compiled_content || super).html_safe
  end

  def title=(new_title)
    super
    if self.draft?
      self.slug = nil
    end
  end

  def labels
    ids = super || ''
    Label.where(id: ids.split(',')).to_a
  end

  def labels=(labels)
    super(labels.map(&:id).join(','))
  end

  def header?
    !header.nil?
  end

  def header
    image_id = super.to_i
    return unless image_id > 0
    Admin::Image.where(id: image_id).first
  end

  def header=(img)
    super(img.id)
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
