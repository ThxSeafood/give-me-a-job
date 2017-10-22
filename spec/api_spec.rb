# frozen_string_literal: false

require_relative 'spec_helper.rb'

describe 'Tests Praise library' do

    VCR.configure do |c|
        c.cassette_library_dir = CASSETTES_FOLDER
        c.hook_into :webmock
    end

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
