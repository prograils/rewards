require 'test_helper'

feature 'CreateComment Feature Test' do
  before do
    @user = FactoryGirl.create(:user)
    login_as(@user, scope: :user)
    @reward = FactoryGirl.create(:reward)
  end

  scenario 'after creating reward it should be shown' do
    visit reward_path(@reward)
    page.must_have_content 'Your comment'
    fill_in 'comment_description', with: 'description_of_my_new_comment'
    click_button 'Create Comment'
    page.must_have_content 'description_of_my_new_comment'
  end
end
