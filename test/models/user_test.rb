require 'test_helper'

class UserTest < ActiveSupport::TestCase
  before do
    @user = FactoryGirl.create(:user)
  end

  def mock_google_auth
    OmniAuth::AuthHash.new(
      provider: 'google_auth2',
      uid: '123456789',
      info: {
        name: 'John Doe',
        email: 'john@company_name.com',
        first_name: 'John',
        last_name: 'Doe'
      },
      credentials: {
        token: 'token',
        refresh_token: 'another_token',
        expires_at: 1354920555,
        expires: true
      },
      extra: {
        raw_info: {
          sub: '123456789',
          email: 'user@domain.example.com',
          email_verified: true,
          name: 'John Doe',
          given_name: 'John',
          family_name: 'Doe',
          profile: 'https://plus.google.com/123456789',
          gender: 'male',
          birthday: '0000-06-25',
          locale: 'en',
          hd: 'company_name.com'
        }
      }
    )
  end

  def test_valid
    assert_equal @user.valid?, true
  end

  def test_find_or_create_for_google_oauth2
    access_token = mock_google_auth
    u = User.find_or_create_for_google_oauth2(access_token)
    assert_equal u.valid?, true
  end

  def test_find_for_google_oauth2
    u_old = FactoryGirl.create(:user, email: 'john@company_name.com')
    access_token = mock_google_auth
    u = User.find_or_create_for_google_oauth2(access_token)
    assert_equal u, u_old
  end
end
