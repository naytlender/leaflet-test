# frozen_string_literal: true

# Field class
class Field < ApplicationRecord
  require 'rgeo/geo_json'
  PROPS_FOR_JSON = %i[id name].freeze

  validates :name, presence: true
  validates :shape, presence: true
  validate :geometry

  def area
    RGeo::Geos.factory(srid: 4326).parse_wkt(shape.to_s).area
  end

  def geo_json
    RGeo::GeoJSON.encode(shape)
  end

  def geo_json=(geo_json)
    return if geo_json == ''
    hash = JSON.parse(geo_json)
    self.shape = RGeo::GeoJSON.decode(hash, json_parser: :json)&.geometry
  end

  def geo_json_with_props
    geo_json.tap do |gj|
      gj[:properties] = PROPS_FOR_JSON.map { |attr| [attr, send(attr)] }.to_h
    end
  end

  def self.shapes
    all.map(&:geo_json_with_props)
  end

  private

  def geometry
    if shape.nil?
      errors.add(:shape, 'is invalid: Areas should not cross.')
    elsif !shape.valid?
      errors.add(:shape, 'is invalid: ' + shape.invalid_reason)
    end
  end
end
