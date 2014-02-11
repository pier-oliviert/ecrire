require 'test_helper'

class ImageTest < ActiveSupport::TestCase

  test 'should only return favorited images' do
    Image.favorites.each do |image|
      assert image.favorite?, 'Image should be favorited'
    end
  end

  test 'path should handle blank base_folder' do
    Rails.configuration.s3.base_folder = ""
    Struct.new('File', :original_filename)
    file = Struct::File.new('some_image.jpg')

    image = Admin::Image.new
    image.post = Admin::Post.first

    assert_equal image.send(:path, file), "#{image.post.id}/some_image.jpg"
  end

  test 'path should handle base_folder' do
    Rails.configuration.s3.base_folder = "my_blog"
    Struct.new('File', :original_filename)
    file = Struct::File.new('some_image.jpg')

    image = Admin::Image.new
    image.post = Admin::Post.first

    assert_equal image.send(:path, file), "my_blog/#{image.post.id}/some_image.jpg"
  end
end
