require 'test_helper'

class RewardTest < ActiveSupport::TestCase
  before do
    @reward = FactoryGirl.create(:reward)
  end

  def test_valid
    assert_equal @reward.valid?, true
  end

  def test_to_s
    reward = FactoryGirl.create(:reward, value: 1, description: 'help with tests')
    assert_equal reward.to_s, "1 point for help with tests"
  end

  def test_cannot_exceed_sum
    @reward.value = 101
    assert_equal @reward.valid?, false
  end

  def test_giver_cannot_be_recipient
    @reward.giver = @reward.recipient
    assert_equal @reward.valid?, false
  end

  def test_value_cannot_be_negative
    @reward.value = -2
    assert_equal @reward.valid?, false
    @reward.value = 0
    assert_equal @reward.valid?, true
  end

  def test_within_month
    now = DateTime.now
    @reward.update_attributes(created_at: now)
    assert_equal Reward.within_month(now.month, now.year).length, 1
    assert_equal Reward.within_month((now - 1.month).month, now.year).length, 0
    FactoryGirl.create(:reward, created_at: now - 1.month)
    assert_equal Reward.within_month(now.month, now.year).length, 1
    assert_equal Reward.within_month((now - 1.month).month, now.year).length, 1
    FactoryGirl.create(:reward, created_at: now - 1.month)
    assert_equal Reward.within_month(now.month, now.year).length, 1
    assert_equal Reward.within_month((now - 1.month).month, now.year).length, 2
  end

  def test_stale
    now = DateTime.now
    @reward.created_at = now - 4.hours
    user1 = FactoryGirl.create(:user, last_sign_in_at: now)
    user2 = FactoryGirl.create(:user, last_sign_in_at: now - 5.hours)
    user3 = FactoryGirl.create(:user, last_sign_in_at: now - 2.days)
    assert_equal @reward.stale?(user1), true
    assert_equal @reward.stale?(user2), false
    assert_equal @reward.stale?(user3), false
  end
end
