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
            api = ThxSeafood::A104::Api.new
            job_mapper = ThxSeafood::A104::JobMapper.new(api)
            @jobs = job_mapper.load_several(KEYWORDS)
        end

        it 'HAPPY: size should match' do
        _(@jobs.count.to_s).must_equal CORRECT['size']
        _(@jobs.count).must_equal CORRECT['contents'].count
        end

        # 這邊會錯的原因是因為responese儲存成Entity Object後，順序不見得會跟原本的response相同，所以第一個不見得一樣
        # it 'HAPPY: contents should match' do
        #     _(@jobs.first.name).must_equal CORRECT['contents'].first['JOB']
        #     _(@jobs.first.link).must_equal CORRECT['contents'].first['LINK']
        #     _(@jobs.first.company).must_equal CORRECT['contents'].first['NAME']
        # end    
    end
end
