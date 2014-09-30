require 'test_helper'

feature 'CreateReward Feature Test' do
  before do
    @user = FactoryGirl.create(:user)
    login_as(@user, scope: :user)
    @user2 = FactoryGirl.create(:user)
    ActionMailer::Base.deliveries = []
  end

  scenario 'after creating reward it should be shown' do
    assert_difference 'Reward.count', 1 do
      visit root_path
      page.must_have_content 'Create new reward'
      fill_in 'reward_description', with: 'description_of_my_new_reward'
      fill_in 'reward_value', with: '12'
      select @user2.to_s, from: 'reward_recipient_id'
      click_button 'Create Reward'
    end
    page.must_have_content 'description_of_my_new_reward'
    @user.reload
    @user2.reload
    assert_equal @user.spent_sum, 12
    assert_equal @user2.received_sum, 12
  end

  scenario 'creating invalid reward should result in showing form again' do
    assert_difference 'Reward.count', 0 do
      visit root_path
      page.must_have_content 'Create new reward'
      fill_in 'reward_description', with: 'description_of_my_new_reward'
      fill_in 'reward_value', with: '1200'
      select @user2.to_s, from: 'reward_recipient_id'
      click_button 'Create Reward'
    end
    page.must_have_content 'Create new reward'
    page.wont_have_content 'description_of_my_new_reward'
    @user.reload
    @user2.reload
    assert_equal @user.spent_sum, 0
    assert_equal @user2.received_sum, 0
  end

  scenario 'when creating reward again errors should be displayed and redirect to previous page after success' do
    assert_difference 'Reward.count', 0 do
      visit root_path
      page.must_have_content 'Create new reward'
      fill_in 'reward_description', with: 'description_of_my_new_reward'
      fill_in 'reward_value', with: '1200'
      select @user2.to_s, from: 'reward_recipient_id'
      click_button 'Create Reward'
    end
    assert_equal current_path, rewards_path
    page.must_have_content 'is too much'
    assert_difference 'Reward.count', 1 do
      visit root_path
      page.must_have_content 'Create new reward'
      fill_in 'reward_description', with: 'description_of_my_new_reward'
      fill_in 'reward_value', with: '12'
      select @user2.to_s, from: 'reward_recipient_id'
      click_button 'Create Reward'
    end
    assert_equal current_path, root_path
    page.must_have_content 'description_of_my_new_reward'
    @user.reload
    @user2.reload
    assert_equal @user.spent_sum, 12
    assert_equal @user2.received_sum, 12
  end
end
