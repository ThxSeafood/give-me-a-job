# frozen_string_literal: false

module ThxSeafood
  # Provides access to job data
  module A104
    # Data Mapper for 104 jobs
    class JobMapper
      def initialize(gateway)
        @gateway = gateway
      end

      def load_several(keywords)
        jobs_data = @gateway.jobs_data(keywords)
        jobs_data.map do |job_data|
          JobMapper.build_entity(job_data)
        end
      end

      def self.build_entity(job_data)
        DataMapper.new(job_data).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(job_data)
          @job = job_data
        end

        def build_entity
          Entity::Job.new(
            name: name,
            link: link,
            company: company,
            lon: lon,
            lat: lat,
            address: address,
            addr_no_descript: addr_no_descript,
            description: description            
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

        def lon
          @job['LON']
        end
        
        def lat
          @job['LAT']
        end

        def address
          @job['ADDRESS']
        end

        def addr_no_descript
          @job['ADDR_NO_DESCRIPT']
        end

        def description
          @job['DESCRIPTION']
        end

      end
    end
  end
end
