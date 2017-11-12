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
    it 'HAPPY: should provide correct jobs attributes' do
      get "#{API_VER}/jobs/#{KEYWORDS}"
      _(last_response.status).must_equal 200
      jobs_data = JSON.parse last_response.body
      _(jobs_data.size).must_be :>, 0
    end
  end
end
