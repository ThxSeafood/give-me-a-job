# frozen_string_literal: false

require 'http'
require_relative 'jobs.rb'

module RepoPraise
  # Library for Github Web API
  class JobAPI
    module Errors
      class NotFound < StandardError; end
      class Unauthorized < StandardError; end
    end

    HTTP_ERROR = {
      404 => Errors::NotFound
    }.freeze

    def initialize(cache: {})
      @cache = cache
    end

    def jobs(keywords)
      url = api_path(keywords)
      jobs_datas = JSON.parse(call_104_url(url).body)['data']
      jobs_datas.map { |job_data| Jobs.new(job_data) }
    end

    private

    def api_path(keywords)
        'http://www.104.com.tw/i/apis/jobsearch.cfm?kws=' + keywords + '&area=6001001000&order=2&fmt=8&cols=JOB%2CNAME%2Clink&pgsz=2000'
    end

    def call_104_url(url)
    #   result = @cache.fetch(url) do
        result = HTTP.get(url)
    #   end

      successful?(result) ? result : raise_error(result)
    end

    def successful?(result)
      HTTP_ERROR.keys.include?(result.code) ? false : true
    end

    def raise_error(result)
      raise(HTTP_ERROR[result.code])
    end
  end
end
