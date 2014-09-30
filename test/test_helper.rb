require 'simplecov'
SimpleCov.start do
  add_filter '/test/'
  add_filter '/config/'
  add_filter '/app/admin/'
end
Rails.env = 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/rails"
require 'database_cleaner'
require "capybara/rails"
require "capybara/rspec/matchers"
require "minitest/rails/capybara"
require 'capybara/poltergeist'

Capybara.javascript_driver = :poltergeist
Capybara.always_include_port = true
Capybara.app_host = 'http://lvh.me'

class ActionController::TestCase
  include Devise::TestHelpers
  include Warden::Test::Helpers
  Warden.test_mode!
  teardown do
    Rails.cache.clear
  end
  setup do
    Rails.cache.clear
  end
end

class Capybara::Rails::TestCase
  include Warden::Test::Helpers
  DatabaseCleaner.strategy = :truncation

  teardown do
    DatabaseCleaner.clean
    DatabaseCleaner.strategy = :transaction
  end
  setup do
    DatabaseCleaner.strategy = :truncation
  end
  before do
    DatabaseCleaner.clean
    DatabaseCleaner.start
  end
  after do
    DatabaseCleaner.clean
    Capybara.reset_sessions!
  end
  self.use_transactional_fixtures = false
end
