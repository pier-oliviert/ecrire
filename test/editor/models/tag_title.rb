require 'test_helper'

puts 'here'
class TagTest < ActiveSupport::TestCase
  test 'Can retrieve all posts associated with a tag' do
    debugger
    assert tags(:ruby).count == 2
  end
end
