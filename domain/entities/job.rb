# frozen_string_literal: false

require 'dry-struct'

module ThxSeafood
  module Entity
    # Domain entity object for 104 job
    class Job < Dry::Struct
      attribute :rank, Types::Int.optional
      attribute :name, Types::Strict::String
      attribute :link, Types::Strict::String
      attribute :company, Types::Strict::String
      attribute :lng, Types::Strict::Float
      attribute :lat, Types::Strict::Float
      attribute :address, Types::Strict::String
      attribute :addr_no_descript, Types::Strict::String
      # attribute :description, Types::Strict::String
      attribute :user_query, Types::Strict::String


      # 這段如果寫了還沒加super，就會把Dry::Struct的初始化給蓋掉，會寫不進去東西
      # def initialize(job_data)
      #   @job = job_data
      # end
  
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
