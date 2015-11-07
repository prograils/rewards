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

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_many :received_rewards, class_name: 'Reward', foreign_key: :recipient_id
  has_many :given_rewards, class_name: 'Reward', foreign_key: :giver_id
  has_many :rewards
  has_many :comments

  scope :active, -> { where(is_active: true) }

  after_initialize :assign_defaults
  after_create :send_mail_to_admins

  def to_s
    full_name.strip.blank? ? email : full_name
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def spent_sum(month = nil, year = nil)
    given_rewards.within_month(month, year).sum(:value)
  end

  def received_sum(month = nil, year = nil)
    received_rewards.within_month(month, year).sum(:value)
  end

  def money_left
    limit - spent_sum
  end

  def send_mail_to_admins
    AdminNotifier.new_user_notify(self).deliver_now
  end

  def try_activating
    user_domain = email.partition('@').last
    app_domain = Rails.application.config.action_mailer.smtp_settings[:domain]
    update_attribute(:is_active, true) if user_domain == app_domain
  end

  def assign_defaults
    self.limit = Setting.default_limit if self.new_record?
  end

  def self.find_or_create_for_google_oauth2(access_token)
    data = access_token.info
    user = find_by_credentials(access_token.provider, access_token.uid)
    user ||= find_by_email(data.email)
    user ||= create_for_google_oauth2(access_token, data)
    user.try_activating
    user
  end

  def self.find_by_credentials(provider, uid)
    User.where(provider: provider, uid: uid).first
  end

  def self.find_by_email(email)
    User.where(email: email).first
  end

  def self.create_for_google_oauth2(access_token, data)
    User.create(
      email: data.email,
      first_name: data.first_name,
      last_name: data.last_name,
      provider: access_token.provider,
      uid: access_token.uid,
      password: Devise.friendly_token[0, 20],
      confirmed_at: Time.now)
  end
end
