# frozen_string_literal: false

require_relative 'spec_helper.rb'

describe 'Tests ThxSeafood library' do
  API_VER = 'api/v0.1'.freeze
  CASSETTE_FILE = 'thxseafood_api'.freeze

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
      get "#{API_VER}/#{KEYWORDS}"
      _(last_response.status).must_equal 200
      jobs_data = JSON.parse last_response.body
      _(jobs_data.size).must_be :>, 0
    end
  end
end
