# frozen_string_literal: false

module RepoPraise
    
        class Jobs
          def initialize(job_data)
            @job = job_data
          end
      
          def name
            @job['JOB']
          end
      
          def link
            @job['LINK']
          end
    
          def company
            @job['NAME']
          end
        end
      end
      