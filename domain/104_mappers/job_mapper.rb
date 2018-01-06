# frozen_string_literal: false

module ThxSeafood
  # Provides access to job data
  module A104
    # Data Mapper for 104 jobs
    class JobMapper
      def initialize(gateway)
        @gateway = gateway
      end

      def get_total_page_num(keywords)
        total_record_num = @gateway.get_total_record_num(keywords)
        total_page_num = (total_record_num + 19) / 20
      end

      def get_total_record_num(keywords)
        total_record_num = @gateway.get_total_record_num(keywords) 
      end

      def load_several(keywords, page)
        jobs_data = @gateway.jobs_data(keywords, page)
        jobs_data.map do |job_data|
          JobMapper.build_entity(job_data, keywords)
        end
      end

      def self.build_entity(job_data, user_query)
        DataMapper.new(job_data, user_query).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(job_data, user_query)
          @job = job_data
          @user_query = user_query
        end

        def build_entity
          Entity::Job.new(
            rank: nil,
            name: name,
            link: link,
            company: company,
            lng: lng,
            lat: lat,
            address: address,
            addr_no_descript: addr_no_descript,
            # description: description,    
            user_query: query
          )
        end

        private

        def name
          @job['JOB']
        end
    
        def link
          @job['LINK']
        end
    
        def company
          @job['NAME']
        end

        def lng
          @job['LON'].to_f
        end
        
        def lat
          @job['LAT'].to_f
        end

        def address
          @job['ADDRESS']
        end

        def addr_no_descript
          @job['ADDR_NO_DESCRIPT']
        end

        # def description
        #   @job['DESCRIPTION']
        # end

        def query
          @user_query
        end

      end
    end
  end
end
