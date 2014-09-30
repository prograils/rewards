require 'test_helper'

describe UsersController do
  before do
    @user = FactoryGirl.create(:user)
    sign_in @user
    @user2 = FactoryGirl.create(:user)
    @user3 = FactoryGirl.create(:user)
    FactoryGirl.create(:user, is_active: false)
    FactoryGirl.create(:user, is_active: false)
    @admin = FactoryGirl.create(:admin_user)
  end

  it 'should show all active users' do
    get :index
    assert_equal User.count, 5
    assert_equal User.active.count, 3
    assert_equal assigns(:users).count, 3
    assert_response :success
    assert_template :index
  end

  it "should get user's data properly when has no activity" do
    get :show, id: @user2
    assert_equal assigns(:user), @user2
    assert_equal assigns(:given_rewards), []
    assert_equal assigns(:received_rewards), []
    assert_equal assigns(:comments), []
  end

  it "should get user's data properly when has activity" do
    given_reward = FactoryGirl.create(:reward, giver: @user2)
    received_reward = FactoryGirl.create(:reward, recipient: @user2)
    comment = FactoryGirl.create(:comment, user: @user2)
    get :show, id: @user2
    assert_equal assigns(:user), @user2
    assert_equal assigns(:given_rewards).count, 1
    assert_equal assigns(:given_rewards).first, given_reward
    assert_equal assigns(:received_rewards).count, 1
    assert_equal assigns(:received_rewards).first, received_reward
    assert_equal assigns(:comments).count, 1
    assert_equal assigns(:comments).first, comment
  end

  it "should get user's data properly when has archived activity" do
    FactoryGirl.create(:archived_reward, giver: @user2)
    FactoryGirl.create(:archived_reward, recipient: @user2)
    FactoryGirl.create(:archived_comment, user: @user2)
    get :show, id: @user2
    assert_equal assigns(:user), @user2
    assert_equal assigns(:given_rewards), []
    assert_equal assigns(:received_rewards), []
    assert_equal assigns(:comments), []
  end

  it "should be able to show user's data sorted" do
    given_reward_1 = FactoryGirl.create(:reward, giver: @user2, recipient: @user, created_at: Time.now - 4.month)
    given_reward_2 = FactoryGirl.create(:reward, giver: @user2, recipient: @user3, created_at: Time.now - 3.hours)
    get :show, id: @user2, q: { s: 'user asc' }
    assert_equal assigns(:given_rewards).length, 2
    assert_equal assigns(:given_rewards).first, given_reward_1
    assert_equal assigns(:given_rewards).last, given_reward_2
    assert_equal assigns(:user), @user2
    assert_equal assigns(:received_rewards), []
    assert_equal assigns(:comments), []

    get :show, id: @user2, q: { s: 'user desc' }
    assert_equal assigns(:given_rewards).length, 2
    assert_equal assigns(:given_rewards).first, given_reward_2
    assert_equal assigns(:given_rewards).last, given_reward_1
  end

  it "admin should be able to update user's limits'" do
    sign_in @admin
    limit_before = @user2.limit
    get :update_users, user: { ids: [@user2.id, @user3.id], limit: 150 }
    @user2.reload
    limit_after = @user2.limit
    refute_equal limit_before, limit_after
  end

  it "admin should be able to change default limit'" do
    sign_in @admin
    u1 = FactoryGirl.build(:user)
    limit_before = u1.limit
    get :set_default_limit, user: { default_limit: limit_before + 50 }
    # assert_equal Setting[:default_limit], limit_before + 50
    u2 = FactoryGirl.build(:user)
    limit_after = u2.limit
    refute_equal limit_before, limit_after
    assert_equal limit_before + 50, limit_after
  end
end
