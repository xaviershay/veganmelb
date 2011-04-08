require 'csv'

orgs = CSV.read(ARGV[0]).map do |row|
  <<-HTML
    <article>
      <h1><a href='#{row[1]}'>#{row[0]}</a></h1>
      <p>#{row[2]}</p>
    </article>
  HTML
end

puts orgs
