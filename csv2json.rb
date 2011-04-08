# coding: utf-8
require 'csv'
require 'json'
require 'geokit'
require 'addressable/uri'

places = CSV.read(ARGV[0], encoding: 'UTF-8').map do |row|
  unless row[6] && row[7]
    res = Geokit::Geocoders::MultiGeocoder.geocode(row[2])

    raise "Could not geocode #{row[0]}: #{row[2]}" unless res.lat
    row[6] = res.lng
    row[7] = res.lat
  end

  {
    name:        row[0],
    location:    {
      lng: row[6],
      lat: row[7]},
    address:     row[2].to_s.gsub(/,? \d+$/, ''),
    phoneNumber: row[3],
    description: row[4],
    url:         Addressable::URI.heuristic_parse(row[5]).to_s,
    type:        row[1]
  }
end

puts places.to_json
