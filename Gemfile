source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

gem "rails", "~> 7.0.4"
gem "sqlite3", "~> 1.4"
gem "puma", "~> 5.0"
gem "redis", "~> 4.0"
gem 'awesome_print'

gem "sprockets-rails"
gem "importmap-rails"
gem "haml-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem 'simple_form'
gem 'bootstrap'

gem "bootsnap", require: false
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'rspec-rails'
  gem 'byebug'
  gem 'factory_bot'
end

group :development do
  gem "web-console"
end
