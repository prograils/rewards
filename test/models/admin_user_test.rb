require 'test_helper'

class AdminUserTest < ActiveSupport::TestCase
  before do
    @admin_user = FactoryGirl.create(:admin_user)
  end

  def test_valid
    assert_equal @admin_user.valid?, true
  end
end
