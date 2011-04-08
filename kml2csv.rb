require 'pp'
require 'csv'
require 'geokit'
require 'json'
require 'nokogiri'
require 'open-uri'

doc = Nokogiri::XML(open(ARGV[0]))

places = doc.css('Placemark').map do |placemark|
  tokens = placemark.css('description').text.split("<br>").map {|x| 
    x.to_s.gsub(/<\/?[^>]*>/, "").strip
  }
  phone_regex = /Ph: ((?:\d+\s?){2,3})/
  web_regex = /www/

  name = placemark.css('name').text.strip
  {
    name:    placemark.css('name').text.strip,
    address: tokens[0],
    type: name == 'Lord of the Fries' ? 'Fast Food' : 'Restaurant',
    description: tokens.last.to_s.gsub("&quot;", "\"").gsub("&#39;", "'"),
    phoneNumber: tokens.grep(phone_regex).to_s[phone_regex, 1],
    url: tokens.grep(web_regex)[0],
    location: {
      lng: placemark.css('coordinates').text.split(',')[0],
      lat: placemark.css('coordinates').text.split(',')[1]
    }
  }
end

csv_string = CSV.generate do |csv|
  places.each do |place|
    csv << [
      place[:name],
      place[:type],
      place[:address],
      place[:phone],
      place[:description],
      place[:url],
      place[:location][:lng],
      place[:location][:lat],
    ]
  end
end

puts csv_string
