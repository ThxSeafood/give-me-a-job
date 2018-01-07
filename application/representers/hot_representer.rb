# frozen_string_literal: true

module ThxSeafood
  class HotRepresenter < Roar::Decorator
    include Roar::JSON

    property :rank
    property :name
    property :link
    property :company
    property :lng
    property :lat
    property :address
    property :addr_no_descript
    # property :description
    property :user_query
    property :city
  end

end