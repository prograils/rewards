require 'test_helper'

feature 'UserSignUp Feature Test' do
  before do
    @admin = FactoryGirl.create(:admin_user)
    ActionMailer::Base.deliveries = []
  end

  scenario "after normal sign up user won't be neither active nor confirmed, email will be sent to admin about new user and to user about confirmation, when user confirms his account he won't be activated" do
    assert_difference 'User.count', 1 do
      visit root_path
      page.must_have_content 'Sign in'
      click_on 'Sign in'
      click_on 'Sign up'
      fill_in 'user_email', with: 'my_email@gmail.com'
      fill_in 'user_password', with: 'my_secret_password'
      fill_in 'user_password_confirmation', with: 'my_secret_password'
      click_button 'Sign up'
    end
    user = User.last
    assert_equal user.email, 'my_email@gmail.com'
    assert_equal user.is_active, false
    assert_equal user.confirmed_at, nil
    ActionMailer::Base.deliveries.length.must_equal 2
    ActionMailer::Base.deliveries.last.to.first.must_equal @admin.email
    ActionMailer::Base.deliveries.last.subject.must_equal 'New user notify'

    ActionMailer::Base.deliveries.first.to.first.must_equal user.email
    ActionMailer::Base.deliveries.first.subject.must_equal 'Confirmation instructions'
    token = ActionMailer::Base.deliveries.first.body.to_s.sub(/^.*confirmation_token=/m, "").split("\"")[0]
    visit user_confirmation_path(confirmation_token: token)
    user.reload
    assert_equal user.is_active, false
  end

  scenario "after sign up with email from authorized domain user won't be neither active nor confirmed, email will be sent to admin about new user and to user about confirmation, when user confirms his account he will be activated" do
    assert_difference 'User.count', 1 do
      visit root_path
      page.must_have_content 'Sign in'
      click_on 'Sign in'
      click_on 'Sign up'
      fill_in 'user_email', with: "my_email@example.com"
      fill_in 'user_password', with: 'my_secret_password'
      fill_in 'user_password_confirmation', with: 'my_secret_password'
      click_button 'Sign up'
    end
    user = User.last
    assert_equal user.email, "my_email@example.com"
    assert_equal user.is_active, false
    assert_equal user.confirmed_at, nil
    ActionMailer::Base.deliveries.length.must_equal 2
    ActionMailer::Base.deliveries.last.to.first.must_equal @admin.email
    ActionMailer::Base.deliveries.last.subject.must_equal 'New user notify'
    ActionMailer::Base.deliveries.first.to.first.must_equal user.email
    ActionMailer::Base.deliveries.first.subject.must_equal 'Confirmation instructions'
    token = ActionMailer::Base.deliveries.first.body.to_s.sub(/^.*confirmation_token=/m, "").split("\"")[0]
    visit user_confirmation_path(confirmation_token: token)
    user.reload
    assert_equal user.is_active, true
  end
end
