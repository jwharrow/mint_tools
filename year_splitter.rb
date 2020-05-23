require 'csv'
require 'pathname'

if ARGV == []
  raise "Need a file!"
end

file = ARGV[0]

if !file.match(/\.csv$/)
 raise "Need a csv!"
end 

if !File.exists?(file)
  raise "#{file} doesn't exist in #{Dir.pwd}"
end

filename = ARGV[0].delete_suffix(".csv")

Dir.exists?(filename) || Dir.mkdir(filename)


headers = CSV.open(file, 'r') { |csv| csv.first }.join(",")

years = []

CSV.foreach(file, headers: :first_row, return_headers: false) do |row|
  year = row[0][-4..-1]
  if years.include?(year)
    year_file = filename + "/" + year + ".csv"
    open(year_file, 'a') do |f|
        f << row
    end

  else
    puts "Processing #{year} ..."
    year_file = filename + "/" + year + ".csv"
    years << year
    open(year_file, 'a') do |f|
        f << headers
        f << "\n"
        f << row
    end
  end
end

