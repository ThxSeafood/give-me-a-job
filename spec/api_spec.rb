# frozen_string_literal: false

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require_relative '../lib/api.rb'

describe 'Tests Praise library' do
  KEYWORDS = 'Internet程式設計師'.freeze
  CORRECT = YAML.safe_load(File.read('spec/fixtures/results.yml'))
  RESPONSE = YAML.load(File.read('spec/fixtures/response.yml'))

  describe 'Job information' do
    before do
      @jobs = RepoPraise::JobAPI.new.jobs(KEYWORDS)
    end

    it 'HAPPY: size should match' do
      _(@jobs.count.to_s).must_equal CORRECT['size']
      _(@jobs.count).must_equal CORRECT['contents'].count
    end

    it 'HAPPY: contents should match' do
        _(@jobs.first.name).must_equal CORRECT['contents'].first['JOB']
        _(@jobs.first.link).must_equal CORRECT['contents'].first['LINK']
        _(@jobs.first.company).must_equal CORRECT['contents'].first['NAME']
    end    
  end
end
