require 'csv'

namespace :import do

  desc 'Uploads geo_locations date and variables'
  task geo_locations: :environment do

    csv_text = File.read(File.join(Rails.root, 'lib', 'data', 'geo_locations.csv'))
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      GeoLocation.create(
        country: row[0],
        state: row[1],
        soc_ref: row[2],
        flu: row[3],
        fmg_full: row[4],
        fmg_reduced: row[5],
        fmg_no_till: row[6],
        fi_low: row[7],
        fi_high_without_manure: row[8],
        fi_high_with_manure: row[9]
      )
    end
    puts "#{GeoLocation.count} geo locations created"
  end
end
