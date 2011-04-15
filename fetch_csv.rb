require 'google_spreadsheet'
require 'highline/import'
require 'csv'

email    = ask("Email:    ")
password = ask("Password: ") {|q| q.echo = false }

session = GoogleSpreadsheet.login(email, password)
spreadsheet = session.spreadsheet_by_key("0Asap85N419MIdGhRQm14SnNhQTFCYUs2TWZFUWJIaHc")

%w(locations.csv online.csv organisations.csv).each_with_index do |file_name, worksheet|
  csv_string = CSV.generate do |csv|
    spreadsheet.worksheets[worksheet].rows.each do |row|
      csv << row
    end
  end

  File.open(file_name, "w") {|f| f.write csv_string }
end
