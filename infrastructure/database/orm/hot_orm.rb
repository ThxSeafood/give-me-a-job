# frozen_string_literal: true

module ThxSeafood
  module Database
    # Object-Relational Mapper for Jobs
    class HotOrm < Sequel::Model(:hots)  
      plugin :timestamps, update_on_create: true
    end
  end
end
  