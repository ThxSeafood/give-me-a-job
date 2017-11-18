# frozen_string_literal: true

require 'dry-monads'

module ThxSeafood

  module FindDatabaseAllJobs
    extend Dry::Monads::Either::Mixin

    def self.call
      jobs = Repository::For[Entity::Job].all

      if jobs
        Right(Result.new(:ok, jobs))
      else
        Left(Result.new(:not_found, 'Could not find stored jobs'))
      end
    end
  end
end
