require 'test_helper'

describe CommentsController do
  before do
    @user = FactoryGirl.create(:user)
    sign_in @user
    @reward = FactoryGirl.create(:reward)
    request.env['HTTP_REFERER'] = root_url
  end

  it 'should create comment properly' do
    assert_difference 'Comment.count', 1 do
      post :create, reward_id: @reward, comment: FactoryGirl.attributes_for(:comment)
    end
  end
end
