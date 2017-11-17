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
      # 後面的else處理是為了應付SQLite不支援regex的情形，所以在local用GET選擇傳回LINK是空的Job資料
      if environment == 'production'
        jobs = Repository::For[Entity::Job]
              .find_jobs_by_using_regexp(input[:jobname])
      else
        jobs = Repository::For[Entity::Job]
              .find_jobs_by_blank_link()
      end
      if jobs
        Right(Result.new(:ok, jobs))
      else
        Left(Result.new(:not_found, 'Could not find stored jobs'))
      end
    end
  end
end
