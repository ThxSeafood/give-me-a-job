source 'https://rubygems.org'
ruby '2.4.2'

# Networking gems
gem 'http'

# Asynchronicity gems
gem 'concurrent-ruby'

# Worker gems
gem 'aws-sdk-sqs', '~> 1'
gem 'faye', '~> 1'
gem 'shoryuken', '~> 3'

# Web app related
gem 'econfig'
gem 'pry' # to run console in production
gem 'puma'
gem 'rack-test' # to diagnose routes in production
gem 'rake' # to run migrations in production
gem 'roda'

# Database related
gem 'hirb'
gem 'sequel'

# Data gems
gem 'dry-struct'
gem 'dry-types'

# Representers
gem 'roar'
gem 'multi_json'

# Services
gem 'dry-monads'
gem 'dry-transaction'

group :test do
  gem 'minitest'
  gem 'minitest-rg'
  gem 'simplecov'
  gem 'vcr'
  gem 'webmock'
end

group :development, :test do
  gem 'sqlite3'

  gem 'database_cleaner'

  gem 'rerun'

  gem 'flog'
  gem 'reek'
  gem 'rubocop'
end

group :production do
  gem 'pg'
  # FB chatbot gems
  # gem 'sinatra'
  gem 'facebook-messenger'
  gem 'httparty'
end
