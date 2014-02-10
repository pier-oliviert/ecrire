require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  test 'should only return favorited images' do
    Image.favorites.each do |image|
      assert image.favorite?, 'Image should be favorited'
    end
  end
end
