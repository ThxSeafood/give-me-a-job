# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:jobs) do
      primary_key :id

      String      :name
      String      :link
      String      :company
      Float       :lng
      Float       :lat
      String      :address
      String      :addr_no_descript
      # String      :description
      String      :user_query

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
