require 'csv'

# Usage: rake import_csv:create_projects
# Make sure the csv file is in tmp/manifesto.csv

namespace :import_csv do
  task :create_projects => :environment do
    csv_text = File.read('tmp/manifesto.csv')
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      puts row.to_hash
      Project.create!(row.to_hash)
    end
  end

end
