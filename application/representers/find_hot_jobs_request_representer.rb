# frozen_string_literal: true

module ThxSeafood
  class FindHotJobsRequestRepresenter < Roar::Decorator
    
    include Roar::JSON
    property :topnum
    property :channel_id

  end
end