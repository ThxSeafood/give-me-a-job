# frozen_string_literal: true

module ThxSeafood
  class LoadDataRequestRepresenter < Roar::Decorator
    include Roar::JSON

    property :page
    property :keywords
    property :page_num
    # property :offset

  end
end