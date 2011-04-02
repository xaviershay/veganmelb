require 'csv'
require 'json'
require 'geokit'

places = CSV.read(ARGV[0]).map do |row|
  res = Geokit::Geocoders::MultiGeocoder.geocode(row[2])

  raise "Could not geocode #{row[0]}: #{row[2]}" unless res.lat

  {
    name:        row[0],
    location:    {
      lat: res.lat,
      lng: res.lng},
    address:     row[2].gsub(/,? \d+$/, ''),
    phoneNumber: row[3],
    description: row[4],
    type:        row[1]
  }
end

puts places.to_json
