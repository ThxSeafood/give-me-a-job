# frozen_string_literal: false

require 'http'

module ThxSeafood
  module 104
  # Gateway class to talk to 104 API
    class Api
      module Errors
        # Not allowed to access resource
        Unauthorized = Class.new(StandardError)
        # Requested resource not found
        NotFound = Class.new(StandardError)
      end

      # Encapsulates API response success and errors
      class Response
        HTTP_ERROR = {
          404 => Errors::NotFound
        }.freeze
  
        def initialize(response)
          @response = response
        end

        def successful?
          HTTP_ERROR.keys.include?(@response.code) ? false : true
        end

        def response_or_error
          successful? ? @response : raise(HTTP_ERROR[@response.code])
        end
      end

      def initialize(cache: {})
        @cache = cache
      end
  
      def jobs_data(keywords)
        url = Api.self_query_path(keywords)
        jobs_datas = JSON.parse(call_104_url(url).body)['data']
        # jobs_datas.map { |job_data| Jobs.new(job_data) }
      end

      def self_query_path(keywords)
          'http://www.104.com.tw/i/apis/jobsearch.cfm?kws=' + keywords + '&area=6001001000&order=2&fmt=8&cols=JOB%2CNAME%2Clink&pgsz=2000'
      end

      private

      def call_104_url(url)
        # result = @cache.fetch(url) do
        result = HTTP.get(url)
        # end
        Response.new(response).response_or_error
      end

  end
end
