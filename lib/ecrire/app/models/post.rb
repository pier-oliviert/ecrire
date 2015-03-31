require 'nokogiri'

class Post < ActiveRecord::Base
  has_one :header, class_name: Image
  has_many :titles, -> { order "titles.created_at DESC" }

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
  scope :without, lambda { |post| where("posts.id != ?", post.id) }

  validates :titles, length: {minimum: 1}

  before_save :update_tags

  attr_writer :tags

  def title=(new_title)
    if self.published?
      self.titles.new(name: new_title)
    else
      title = self.titles.first || self.titles.new
      title.post = self
      title.name = new_title
    end
  end

  def title
    (self.titles.first || self.titles.new).name
  end

  def year
    published_at.year
  end

  def month
    published_at.month
  end

  def slug
    self.titles.first.slug
  end

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

  def header?
    !self.header.nil? && !self.header.url.blank?
  end

  def tags
    @tags ||= Tag.where("tags.id in (?)", super || [])
  end

  protected

  def update_tags
    ids = tags.map(&:id)
    unless ids == read_attribute(:tags)
      write_attribute(:tags, ids)
    end
  end

end
