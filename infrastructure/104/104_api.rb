# frozen_string_literal: false

require 'http'

module ThxSeafood
  module A104
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

      def initialize()
        
      end
  
      def jobs_data(keywords)
        url = Api.query_path(keywords)
        jobs_datas = JSON.parse(call_104_url(url).body)['data']
        # jobs_datas.map { |job_data| Jobs.new(job_data) }
      end

      def self.query_path(keywords)
          'http://www.104.com.tw/i/apis/jobsearch.cfm?kws=' + keywords +'&order=1'+'&kwop=2'+'&fmt=8'+'&pgsz=200'+'&page=1'+'&incs=2'+'&cols=JOB%2CNAME%2CLINK%2CLAT%2CLON%2CADDR_NO_DESCRIPT%2CADDRESS%2CDESCRIPTION'
      end

      private

      def call_104_url(url)
        # result = @cache.fetch(url) do
        result = HTTP.get(url)
        # end
        Response.new(result).response_or_error
      end
    end  
  end
end
