class UserNotifier < ActionMailer::Base
  def got_new_reward(reward)
    @reward = reward
    mail to: reward.recipient.email
  end
end
