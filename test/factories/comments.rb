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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    sequence(:description) { |n| "my_comments_description_#{n}" }
    reward
    user

    factory :archived_comment do
      reward { Reward.where(is_archived: true).first_or_create!(FactoryGirl.attributes_for(:reward)) }
    end
  end
end
