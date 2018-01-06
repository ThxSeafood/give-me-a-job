# frozen_string_literal: true

require 'dry/transaction'

module ThxSeafood
  # Transaction to load repo from Github and save to database
  class LoadFrom104
    include Dry::Transaction

    step :get_jobs_from_104
    # step :check_if_job_already_loaded
    step :store_jobs_in_repository

    def get_jobs_from_104(input)
      jobs = A104::JobMapper.new(A104::Api.new).load_several(input[:jobname], 1)
      Right(jobs: jobs)
    rescue StandardError
      Left(Result.new(:bad_request, 'Jobs not found'))
    end

    # def check_if_job_already_loaded(input)
    #   if Repository::For[input[:repo].class].find(input[:repo])
    #     Left(Result.new(:conflict, 'Repo already loaded'))
    #   else
    #     Right(input)
    #   end
    # end

    def store_jobs_in_repository(input)
      # stored_jobs = input[:jobs].map{ |job| Repository::For[job.class].find_or_create(job) }
      stored_jobs = input[:jobs].map{ |job| Repository::For[job.class].create(job) }
      Right(Result.new(:created, stored_jobs))
    rescue StandardError => e
      puts e.to_s
      Left(Result.new(:internal_error, 'Could not store jobs'))
    end
  end
end