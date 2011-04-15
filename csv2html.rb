require 'csv'

orgs = CSV.read(ARGV[0], headers: true).map do |row|
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

puts orgs
