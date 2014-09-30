require 'test_helper'

class EmojiHelperTest < ActionView::TestCase
  include ERB::Util
  include EmojiHelper

  test "should change content if emoji image found" do
    content = "Why? :smile:"
    refute_equal content, emojify(content)
  end
  test "shouldn't change content unless emoji image found" do
    content = "Happy :D:"
    assert_equal content, emojify(content)
  end
end
