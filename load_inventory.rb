require 'pry'

# load_inventory.rb <filename>

# This utility is responsible for determining the format
# of the incoming inventory data file, parsing it, and
# exporting it to our master inventory file.
# 
# The parse methods return a hash of our inventory.



def get_supplier_format(file)
  File.extname(file).gsub(".", "")
end

def parse_csv(file)
  file.each_line do |line|
    data = line.chomp.split(',')
    album = Hash.new

    # check if artist is a compound artist aka "Peter, Paul and Mary"
    if data[0][0] == "\""
      end_of_artist = line.rindex("\"")
      album[:artist] = line[1..end_of_artist-1]
      line = line[end_of_artist+2..-1]
      data = line.split(',')

      album[:title] = data[0]
      album[:format] = data[1]
      album[:release_year] = data[2]
    else
      album[:artist] = data[0]
      album[:title] = data[1]
      album[:format] = data[2]
      album[:release_year] = data[3]
    end

    puts album
    # store.add_inventory(album)
  end

end

def parse_pipe(file)
end

# def read_inventory(file)
# end

# def update_inventory(existing_data, new_data)
# end

# def write_inventory(data, file)
# end

def main
  puts "loading the inventory"
  puts "please be patient"

  supplier_filename = ARGV[0]
  supplier_file = File.new(supplier_filename, "r")
  
  format = get_supplier_format(supplier_file)
  
  if format == "csv"
    data = parse_csv(supplier_file)
  elsif format == "pipe"
    data = parse_pipe(supplier_file)
  else
    error = "Unrecognized format"
    return error
  end

  # write_inventory(data, master)

end

main

puts "done"