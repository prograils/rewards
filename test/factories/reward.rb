# == Schema Information
#
# Table name: reward
#
#  id           :integer          not null, primary key
#  description  :string(255)
#  value        :integer
#  status       :boolean
#  category_id  :integer
#  giver_id     :integer
#  recipient_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reward do
    sequence(:description) { |n| "my_rewards_description_#{n}" }
    value 1
    is_archived false
    giver
    recipient

    factory :archived_reward do
      is_archived true
    end
  end
end
