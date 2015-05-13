require 'nokogiri'

##
# Posts written by users stored in database
#
# == Available scopes
#
# Scopes are builtin methods to facilitate retrieving posts
# from the database. Scopes can also be chained to narrow your query
# even more.
#
# +published+: Return posts that are published
#
# +drafted+: Return posts that are NOT published 
#
# +search_by_title+: Return all post that have a title that match 
# the key you provide
#
# 
class Post < ActiveRecord::Base
  has_one :header, class_name: Image
  has_many :titles, -> { order "titles.created_at DESC" }

  scope :published, lambda { status("published") }
  scope :drafted, lambda { status("drafted") }
  scope :status, lambda {|status|
    if status.eql?("published")
      where "posts.published_at IS NOT NULL"
    else
      where "posts.published_at IS NULL"
    end
  }

  scope :search_by_title, lambda {|title|
    ids = Title.search_by_name(title).map(&:post_id).compact
    Post.includes(:titles).where('posts.id in (?)', ids)
  }

  scope :without, lambda { |post| where("posts.id != ?", post.id) }

  validates :titles, length: {minimum: 1}

  before_save :update_tags

  attr_writer :tags

  #:nodoc:
  def title=(new_title)
    if self.published?
      self.titles.new(name: new_title)
    else
      title = self.titles.first || self.titles.new
      title.post = self
      title.name = new_title
    end
  end

  ##
  # Return the current title for this post
  #
  def title
    (self.titles.first || self.titles.new).name
  end

  ##
  # Return the slug link to the current title
  #
  def slug
    self.titles.first.slug
  end

  ##
  # Returns the year this post was published
  #
  def year
    published_at.year
  end

  ##
  # Returns the month this post was published
  #
  def month
    published_at.month
  end

  #:nodoc:
  def status=(new_status)
    if new_status.eql? "publish"
      publish!
    end
  end

  ##
  # Publish this post if it is not yet published
  # 
  # Update the database with the publish date
  #
  def publish!
    return unless published_at.nil?
    self.published_at = DateTime.now
    save!
  end

  ##
  # Returns whether this post is published or not
  #
  def published?
    !draft?
  end

  ##
  # The opposite of +published?+
  #
  def draft?
    published_at.nil?
  end

  ##
  # Returns the content of this post. Depending on the current status
  # of this post, it can be one of three things:
  # 
  # - Compiled content;
  # - Markdown content;
  # - Empty string.
  #
  # This method should be used when trying to render the body of a post
  # to a page in HTML.
  #
  def content
    (self.compiled_content || super || '').html_safe
  end

  ##
  # Returns the compiled excerpt for this post.
  # The excerpt is based on content but only returns text.
  #
  # The excerpt is parsed from the content and it also 
  # filters out images and header.
  # 
  def excerpt
    (self.compiled_excerpt || "").html_safe
  end

  ##
  # Returns true if an image header was set for this post
  #
  def header?
    !self.header.nil? && !self.header.url.blank?
  end

  ##
  # Returns the list of Tags link set for this post
  #
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
