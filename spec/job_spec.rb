# frozen_string_literal: false

require_relative 'spec_helper.rb'
require 'econfig'

describe 'Tests Praise library' do
    extend Econfig::Shortcut
    Econfig.env = 'development'
    Econfig.root = '.'

    CORRECT = YAML.safe_load(File.read('spec/fixtures/results.yml'))
    CASSETTE_FILE = '104_api_cassette'.freeze

    before do
        VCR.insert_cassette CASSETTE_FILE,
                            record: :new_episodes,
                            match_requests_on: %i[method uri headers]
    end

    after do
        VCR.eject_cassette
    end

    describe 'Job information' do
        before do
            api = ThxSeafood::104::Api.new
            job_mapper = ThxSeafood::104::JobMapper.new(api)
            @jobs = job_mapper.load_several(KEYWORDS)
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
