require 'test_helper'
require 'editor/test_helper'

class TitleTest < ActiveSupport::TestCase
  test "length of name" do
    title = Title.new(name: '', post: posts(:published))
    assert !title.save
    assert title.errors.has_key?(:name)

    title.name = 'a'
    assert title.save, title.errors.full_messages.to_sentence
  end

  test "uniqueness" do
    persisted = titles(:draft)
    title = Title.new(name: persisted.name, post: posts(:published))
    assert !title.save, title.errors.full_messages.to_a
    assert title.errors.has_key?(:uniqueness), title.errors.full_messages.to_a
  end

  test "editing only possible when it's a draft" do
    title = titles(:draft)
    title.name = "Changing it."
    assert title.save, title.errors.full_messages.to_sentence

    title = titles(:published_history)
    title.name = "Shouldn't change"
    assert !title.save
  end

end
