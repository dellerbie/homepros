source 'http://rubygems.org'

ruby "1.9.3"

gem 'rails', '3.2.13'
gem 'pg'
gem 'haml-rails'
gem 'devise'
gem 'jquery-rails'
gem 'simple_form'
gem 'seed-fu'
gem 'carrierwave'
gem "fog", "~> 1.3.1"
gem 'mini_magick'
gem 'remotipart', '~> 1.0'
gem "aws-ses", :require => 'aws/ses'
gem 'will_paginate'
gem 'friendly_id'
gem 'stripe_event'
gem 'stripe'
gem 'figaro'
gem 'unicorn'
gem 'asset_sync'
gem 'activeadmin'
gem 'sass-rails'
gem "meta_search", '>= 1.1.0.pre'
gem 'airbrake'
gem 'pg_search'
gem 'resque', "~> 1.22.0"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'therubyracer'
  gem 'less-rails'
  gem 'twitter-bootstrap-rails'
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'faker'
  gem "rspec-rails", "~> 2.0"
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-bundler'
end

group :development do
  gem 'nokogiri'
  gem 'socksify'
  gem 'quiet_assets'
end

group :test do 
  gem 'shoulda'
  gem 'database_cleaner'
  gem 'email_spec'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'capybara-webkit', github: 'thoughtbot/capybara-webkit', branch: 'master'
end