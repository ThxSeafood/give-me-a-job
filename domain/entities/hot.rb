# frozen_string_literal: false

require 'dry-struct'

module ThxSeafood
  module Entity

    class Hot < Dry::Struct
      attribute :rank, Types::Int.optional
      attribute :name, Types::Strict::String
      attribute :link, Types::Strict::String
      attribute :company, Types::Strict::String
      attribute :lng, Types::Strict::Float
      attribute :lat, Types::Strict::Float
      attribute :address, Types::Strict::String
      attribute :addr_no_descript, Types::Strict::String
      # attribute :description, Types::Strict::String
      attribute :user_query, Types::Strict::String
      attribute :city, Types::Strict::String

    end  
  end   
end
