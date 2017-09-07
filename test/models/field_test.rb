# frozen_string_literal: true

require 'test_helper'

class FieldTest < ActiveSupport::TestCase
  test 'should not save field if shape is not valid' do
    geo_hash = {
      "type"=>"MultiPolygon",
      "coordinates"=>[[[
        [-5, -5], [-5, 0], [5, 0], [5, 5], [-5, -5]
      ]]]
    }
    shape = RGeo::GeoJSON.decode(geo_hash, json_parser: :json)
    field = Field.new
    field.name = 'random_field'
    field.shape = shape

    assert_equal(shape.invalid_reason, 'Self-intersection[0 0 0]')
    assert_equal(shape.valid?, false)
    assert_not field.save
  end
end
