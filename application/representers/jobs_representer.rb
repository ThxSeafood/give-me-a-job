# frozen_string_literal: true

require_relative 'job_representer'

# Represents essential Repo information for API output
module ThxSeafood
  class JobsRepresenter < Roar::Decorator
    include Roar::JSON
    collection :jobs, extend: JobRepresenter
  end
end
