# frozen_string_literal: true

require 'dry-monads'

module ThxSeafood
  # Service to find a repo from our database
  # Usage:
  #   result = FindDatabaseRepo.call(ownername: 'soumyaray', reponame: 'YPBT-app')
  #   result.success?
  module FindDatabaseJobs
    extend Dry::Monads::Either::Mixin

    def self.call(input)
      # 這邊得改成回傳jobname裡包含keywords的job entity array (得改寫Jobs，也許要加個方法)
      jobs = Repository::For[Entity::Job]
             .find_jobs_by_blank_link()
      if repo
        Right(Result.new(:ok, jobs))
      else
        Left(Result.new(:not_found, 'Could not find stored jobs'))
      end
    end
  end
end
