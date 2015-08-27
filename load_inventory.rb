require 'pry'
require './store.rb'
require './album.rb'
require './stock_item.rb'

# load_inventory.rb <filename>

# This utility is responsible for determining the format
# of the incoming inventory data file, parsing it, and
# exporting it to our master inventory file.
#
# The parse methods return a hash of our inventory.

def get_supplier_format(file)
  File.extname(file).gsub('.', '')
end

def sentance_case(offending_string)
  offending_string.gsub(/\w+/) do |word|
    word.capitalize
  end
end

def parse_csv(file)
  store = Store.new
  file.each_line do |line|
    data = line.chomp.split(',')
    supplier_album = {}

    # check if artist is a compound artist aka "Peter, Paul and Mary"
    # if it is, take the first chunk of the line then parse into fields
    # if not, parse directly to fields
    if data[0][0] == "\""
      end_of_artist = line.rindex("\"")
      supplier_album[:artist] = sentance_case(line[1..end_of_artist - 1])
      line = line[end_of_artist + 2..-1]
      data = line.split(',')

      supplier_album[:title] = sentance_case(data[0])
      supplier_album[:format] = data[1].upcase
      supplier_album[:release_year] = data[2]
    else
      supplier_album[:artist] = sentance_case(data[0])
      supplier_album[:title] = sentance_case(data[1])
      supplier_album[:format] = data[2].upcase
      supplier_album[:release_year] = data[3]
    end

    # we assume one album per line -
    # let the store worry about correctly adding to inventory.
    supplier_album[:quantity] = 1
    store.add_inventory(supplier_album)
  end
  store.save_inventory
end

def parse_pipe(file)

  store = Store.new
  file.each_line do |line|
    data = line.chomp.split('|')
    supplier_album = {}

    # use [-2] to remove trailing spaces except on last element.
    # starting from index 1 to remove preceeding spaces
    supplier_album[:quantity] = data[0][0..-2].to_i
    supplier_album[:format] = data[1][1..-2].upcase
    supplier_album[:release_year] = data[2][1..-2]
    supplier_album[:artist] = sentance_case(data[3][1..-2])
    supplier_album[:title] = sentance_case(data[4][1..-1])
    store.add_inventory(supplier_album)
  end
  store.save_inventory
end

def main
  supplier_filename = ARGV[0]
  supplier_file = File.new(supplier_filename, 'r')
  format = get_supplier_format(supplier_file)
  if format == 'csv'
    parse_csv(supplier_file)
  elsif format == 'pipe'
    parse_pipe(supplier_file)
  else
    error = 'Unrecognized format'
    return error
  end
end

main
