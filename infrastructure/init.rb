# frozen_string_literal: false

folders = %w[104 database/orm]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end