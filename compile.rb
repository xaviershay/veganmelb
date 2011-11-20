#!/usr/bin/env ruby

require 'erb'
require 'csv'
require 'json'

require 'geokit'
require 'addressable/uri'

def csv2json(filename)
  places = CSV.read(filename, encoding: 'UTF-8').map do |row|
    next if row[0] == 'Name'
    unless row[6].to_s.length > 0 && row[7].to_s.length > 0
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
  JSON.pretty_generate(places.compact)
end

def csv2html(content)
  CSV.read(content, headers: true).map do |row|
    if row[3]
      <<-HTML
        <article class='business'>
          <h1><a href='#{row[1]}'>#{row[0]}</a></h1>
          <h2>#{row[3]}</h2>
          <p>#{row[2]}</p>
        </article>
      HTML
    else
      <<-HTML
        <article>
          <h1><a href='#{row[1]}'>#{row[0]}</a></h1>
          <p>#{row[2]}</p>
        </article>
      HTML
    end
  end
end

%w(organisations business).each do |category|
  template = ERB.new(File.read("templates/#{category}.erb"))
  content = csv2html("data/#{category}.csv").join("\n")
  out = template.result(binding)
  File.open("public/#{category}.html", "w") {|f| f.write(out) }
end

File.open("public/static/places.json", "w") do |f|
  f.write csv2json('data/locations.csv')
end
