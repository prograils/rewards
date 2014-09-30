require 'test_helper'

describe RewardsController do
  before do
    @user = FactoryGirl.create(:user)
    sign_in @user
    @user2 = FactoryGirl.create(:user)
    @reward_attr = {}
    @reward_attr[:description] = 'something about reward'
    @reward_attr[:value] = 1
    @reward_attr[:recipient_id] = @user2.id
    session[:return_to] ||= root_path
  end

  it 'should create reward properly' do
    assert_difference 'Reward.count', 1 do
      post :create, reward: @reward_attr
    end
    assert_equal @user.spent_sum, 1
    assert_equal @user2.received_sum, 1
    assert_response :redirect
    assert_redirected_to root_url
  end

  it "shouldn't create reward with value greater than possible" do
    @reward_attr[:value] = 101
    assert_difference 'Reward.count', 0 do
      post :create, reward: @reward_attr
    end
    assert_equal @user.spent_sum, 0
    assert_equal @user2.received_sum, 0
  end

  it "shouldn't create reward for inactive recipient" do
    @user3 = FactoryGirl.create(:user, is_active: false)
    @reward_attr[:recipient_id] = @user3.id
    assert_difference 'Reward.count', 0 do
      post :create, reward: @reward_attr
    end
    assert_equal @user.spent_sum, 0
    assert_equal @user2.received_sum, 0
  end

  it "shouldn't create reward without description" do
    @reward_attr[:description] = nil
    assert_difference 'Reward.count', 0 do
      post :create, reward: @reward_attr
    end
    assert_equal @user.spent_sum, 0
    assert_equal @user2.received_sum, 0
  end

  it 'should show index' do
    get :index
    assert_response :success
    assert_equal assigns(:rewards), []
  end
end
