# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  first_name             :string(255)
#  last_name              :string(255)
#  is_active              :boolean          default(FALSE)
#  created_at             :datetime
#  updated_at             :datetime
#  limit                  :integer          default(0)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "my_email_#{n}@domain_name.com" }
    password 'litost'
    password_confirmation { |p| p.password }
    confirmed_at Time.now
    sequence(:first_name) { |n| "my_first_name_#{n}" }
    sequence(:last_name) { |n| "my_last_name_#{n}" }
    is_active true
    limit { Setting[:default_limit] }

    after :build do
      FactoryGirl.create(:admin_user) unless AdminUser.first
    end

    factory :giver, class: User do
    end

    factory :recipient, class: User do
    end
  end
end
