source "https://rubygems.org"

ruby "3.3.6"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.6"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# HTTP client for external API calls
gem "faraday", "~> 2.7"

# Environment variables management
gem "dotenv-rails", "~> 2.8"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
# gem "rack-cors"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ]
  
  # Testing framework
  gem "rspec-rails", "~> 6.0"
  
  # Test data factories
  gem "factory_bot_rails", "~> 6.2"
  
  # Mock HTTP requests in tests
  gem "webmock", "~> 3.18"

  # API documentation and testing
  gem 'rswag-specs'
  gem 'rswag-api'
  gem 'rswag-ui'
end

group :development do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "pry-rails"
  gem "pry-byebug"
end

