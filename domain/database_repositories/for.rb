# frozen_string_literal: true

module ThxSeafood
  module Repository
    For = {
      Entity::Job => Jobs,
      Entity::Hot => Hots
    }.freeze
  end
end
