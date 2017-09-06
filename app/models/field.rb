class Field < ApplicationRecord
  require 'rgeo/geo_json'
  PROPS_FOR_JSON = %i(id name)

  validates :name, presence: true
  validates :shape, presence: true
  validate :geometry

  def area
    RGeo::Geos.factory(:srid => 4326).parse_wkt(self.shape.to_s).area
  end

  def geo_json
    RGeo::GeoJSON.encode(shape)
  end

  def geo_json=(geo_json)
    if geo_json == ''
      return nil
    elsif RGeo::GeoJSON.decode(JSON.parse(geo_json), json_parser: :json).present?
      self.shape = RGeo::GeoJSON.decode(JSON.parse(geo_json), json_parser: :json).geometry
    end
  end

  def geo_json_with_props
    geo_json.tap do |gj|
      gj[:properties] = PROPS_FOR_JSON.map{|attr| [attr, send(attr)]}.to_h
    end
  end

  def self.shapes
    all.map do |field|
      field.geo_json_with_props
    end
  end

  private
  def geometry
    unless RGeo::GeoJSON.encode(self.shape).present?
      self.errors.add(:shape, 'is invalid')
    end
  end
end
