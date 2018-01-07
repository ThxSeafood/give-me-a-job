# frozen_string_literal: true

require_relative 'hot_representer'

module ThxSeafood
  class CityHotJobsRepresenter < Roar::Decorator
    include Roar::JSON

    collection :taipei, extend: HotRepresenter, class: OpenStruct
    collection :new_taipei, extend: HotRepresenter, class: OpenStruct
    collection :taoyuan, extend: HotRepresenter, class: OpenStruct
    collection :hsinchu, extend: HotRepresenter, class: OpenStruct
    collection :taichung, extend: HotRepresenter, class: OpenStruct
    collection :tainan, extend: HotRepresenter, class: OpenStruct
    collection :kaohsiung, extend: HotRepresenter, class: OpenStruct
  end
end