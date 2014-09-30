# == Schema Information
#
# Table name: rewards
#
#  id           :integer          not null, primary key
#  description  :string(255)
#  value        :integer
#  is_archived  :boolean          default(FALSE)
#  giver_id     :integer
#  recipient_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Reward < ActiveRecord::Base
  paginates_per 10

  belongs_to :giver, class_name: 'User'
  belongs_to :recipient, class_name: 'User'
  has_many :comments, dependent: :destroy

  validates :description, :value, :giver_id, :recipient_id, presence: true
  validates :value, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :cannot_exceed_sum
  validate :recipient_must_be_active
  validate :giver_must_be_active
  validate :giver_cannot_be_recipient

  scope :not_archived, -> { where(is_archived: false) }
  scope :ordered, -> { order('created_at DESC') }

  after_create :notify_recipient

  def notify_recipient
    UserNotifier.got_new_reward(self).deliver
  end

  def to_s
    "#{value_with_unit} for #{description}"
  end

  def value_with_unit
    "#{value} #{(value == 1) ? 'point' : 'points'}"
  end

  def self.within_month(month = nil, year = nil)
    current_month_start = Time.new(year || Time.now.year, month || Time.now.month, 1, 0, 0)
    next_month_start = current_month_start + 1.month
    where(created_at: (current_month_start...next_month_start))
  end

  def stale?(user)
    created_at < user.last_sign_in_at
  end

  def cannot_exceed_sum
    errors.add(:value, 'is too much') if giver.limit < giver.spent_sum + value
  end

  def recipient_must_be_active
    errors.add(:recipient, 'must be active user') unless recipient.is_active?
  end

  def giver_must_be_active
    errors.add(:giver, 'must be active user') unless giver.is_active?
  end

  def giver_cannot_be_recipient
    errors.add(:recipient, 'must be someone else') if giver == recipient
  end
end
