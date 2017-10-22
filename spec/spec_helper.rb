# frozen_string_literal: false

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../lib/api.rb'

KEYWORDS = 'Internet程式設計師'.freeze
CORRECT = YAML.safe_load(File.read('spec/fixtures/results.yml'))
RESPONSE = YAML.load(File.read('spec/fixtures/response.yml'))

CASSETTES_FOLDER = 'spec/fixtures/cassettes'.freeze
CASSETTE_FILE = 'api_cassette'.freeze
