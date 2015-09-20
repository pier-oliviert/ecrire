require 'test_helper'

class TagTest < ActiveSupport::TestCase
  test 'Can retrieve all posts associated with a tag' do
    tag = tags(:ruby)
    published = Post.published.select do |post|
      post.tags.include? tag
    end
    drafted = Post.drafted.select do |post|
      post.tags.include? tag
    end

    assert tags(:ruby).posts.count == published.count + drafted.count
    assert tags(:ruby).posts.published.count == published.count
    assert tags(:ruby).posts.drafted.count == drafted.count
  end
end
