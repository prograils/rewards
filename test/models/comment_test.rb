require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  before do
    @comment = FactoryGirl.create(:comment, description: "comment's description")
  end

  def test_valid
    assert_equal @comment.valid?, true
  end

  def test_to_s
    assert_equal @comment.to_s, "comment's description"
  end

  def test_stale
    now = DateTime.now
    @comment.created_at = now - 4.hours
    user1 = FactoryGirl.create(:user, last_sign_in_at: now)
    user2 = FactoryGirl.create(:user, last_sign_in_at: now - 5.hours)
    user3 = FactoryGirl.create(:user, last_sign_in_at: now - 2.days)
    assert_equal @comment.stale?(user1), true
    assert_equal @comment.stale?(user2), false
    assert_equal @comment.stale?(user3), false
  end
end
