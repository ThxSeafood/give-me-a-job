# frozen_string_literal: false

require 'dry-struct'

module ThxSeafood
  module Entity
    # Domain entity object for git contributors
    class Job < Dry::Struct
      attribute :name, Types::Strict::String
      attribute :link, Types::Strict::String
      attribute :company, Types::Strict::String

      def initialize(job_data)
        @job = job_data
      end
  
      # def name
      #   @job['JOB']
      # end
  
      # def link
      #   @job['LINK']
      # end
  
      # def company
      #   @job['NAME']
      # end

    end  
  end   
end
