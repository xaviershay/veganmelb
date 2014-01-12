#!/usr/bin/env ruby

require 'erb'
require 'csv'
require 'json'

require 'geocoder'
require 'addressable/uri'

def geocode(places)
  places.map do |place|
    unless place['location']
      res = Geocoder.search(place['address'] + ", Australia", :bias => 'au')
      raise "Could not geocode #{row[0]}: #{row[2]}" unless res.any?
      res = res.first
      place['location'] = {
        lng: res.longitude,
        lat: res.latitude
      }
    end
    place
  end
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

existing_places = JSON.parse(File.read("public/static/places.json"))

File.open("public/static/places.json", "w") do |f|
  f.write JSON.pretty_generate(geocode(existing_places))
end
