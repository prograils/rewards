ruby File.read(File.expand_path('../.ruby-version', __FILE__)).chomp
source ENV.fetch('GEM_SOURCE', 'https://rubygems.org')

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.6'

gem 'pg'

gem 'therubyracer'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.1'

# Use jquery as the JavaScript library
gem 'jquery-rails'
#gem 'jquery-ui-rails'

gem 'bootstrap-sass'
gem 'haml', '>=3.1.6'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'jquery-turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

gem 'inherited_resources'
gem 'devise'
gem 'omniauth-google-oauth2'
gem 'simple_form'
gem 'gemoji'
gem 'activeadmin', github: 'gregbell/active_admin'
gem 'kaminari'
gem 'sidekiq-cron'
gem 'rails-settings-cached'
gem 'rb-readline'

# React
gem 'react-rails', '~> 1.4.0'

group :test do
  gem 'minitest-rails-capybara'
  gem 'poltergeist'
  gem 'database_cleaner'
  gem 'simplecov', '~> 0.9.0', require: false
end

group :development, :test do
  gem 'minitest-rails'
  gem 'factory_girl_rails'
  gem 'dotenv-rails'
  gem 'quiet_assets'
end

group :development do
  gem 'annotate'
end

group :doc do
  gem 'sdoc', require: false
end

group :production do
  gem 'unicorn'
  gem 'rails_12factor'
end


