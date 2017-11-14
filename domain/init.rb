# frozen_string_literal: true

folders = %w[entities database_repositories 104_mappers]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
