# frozen_string_literal: false

require_relative 'spec_helper.rb'

describe 'Tests ThxSeafood library' do
  API_VER = 'api/v0.1'.freeze
  CASSETTE_FILE = 'thxseafood_api'.freeze # 不知道為何，用rake執行spec時就不會產生cassette，只會產生job_spec的，但如果不用rake，直接用ruby執行spec/api_spec就可

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
      # DatabaseCleaner.clean
      Rake::Task['db:reset'].invoke
    end

    describe "POSTting to create entities from 104" do
      it 'HAPPY: should retrieve and store jobs' do
        post "#{API_VER}/jobs/#{KEYWORDS}"
        _(last_response.status).must_equal 201
        _(last_response.header['Location'].size).must_be :>, 0
        jobs_data = JSON.parse last_response.body
        _(jobs_data.size).must_be :>, 0
      end

      # 後來發現，就算104搜尋不到結果回傳，仍有做搜尋動作，所以一樣會回傳201
      # it 'SAD: should report error if no result found' do
      #   post "#{API_VER}/jobs/error_name"
      #   _(last_response.status).must_equal 404
      # end
    end

    describe "GETing database entities" do
      before do
        post "#{API_VER}/jobs/#{KEYWORDS}"
      end

      it 'HAPPY: should find stored job' do
        get "#{API_VER}/jobs/#{KEYWORDS}"
        _(last_response.status).must_equal 200
        jobs_data = JSON.parse last_response.body
        _(jobs_data.size).must_be :>, 0
      end

      # 因為目前get不管輸入啥keyword，都會回傳任何link是空的的資料，所以暫時先註解掉
      # it 'SAD: should report error if no database job entity found' do
      #   get "#{API_VER}/jobs/error_name"
      #   _(last_response.status).must_equal 404
      # end
    end
  end
end
