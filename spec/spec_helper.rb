# frozen_string_literal: false

ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative 'test_load_all'

load 'Rakefile'
Rake::Task['db:reset'].invoke

# 注意，rack-test的URI只能輸入ASCII瑪，也就是說不能在裡面放中文字，所以KEYWORDS這裡只能寫英文
KEYWORDS = 'Internet'.freeze

# RESPONSE = YAML.load(File.read('spec/fixtures/response.yml'))

CASSETTES_FOLDER = 'spec/fixtures/cassettes'.freeze
# CASSETTE_FILE = 'api_cassette'.freeze

VCR.configure do |c|
  c.cassette_library_dir = CASSETTES_FOLDER
  c.hook_into :webmock
  c.ignore_hosts 'sqs.us-east-1.amazonaws.com'

  # github_token = app.config.gh_token
  # c.filter_sensitive_data('<GITHUB_TOKEN>') { github_token }
  # c.filter_sensitive_data('<GITHUB_TOKEN_ESC>') { CGI.escape(github_token) }
end
