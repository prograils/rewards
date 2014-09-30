# == Schema Information
#
# Table name: comments
#
#  id          :integer          not null, primary key
#  description :string(255)
#  reward_id   :integer
#  user_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Comment < ActiveRecord::Base
  belongs_to :reward
  belongs_to :user

  validates :description, presence: true

  scope :not_archived, -> { joins(:reward).where(rewards: { is_archived: false }) }

  def to_s
    description
  end

  def stale?(user)
    created_at < user.last_sign_in_at
  end
end
