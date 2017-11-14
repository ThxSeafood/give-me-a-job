# frozen_string_literal: true

module ThxSeafood
    module Database
      # Object-Relational Mapper for Jobs
      class JobOrm < Sequel::Model(:jobs)  
        plugin :timestamps, update_on_create: true
      end
    end
  end
  