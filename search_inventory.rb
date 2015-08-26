require 'pry'
require './store.rb'
require './album.rb'

store = Store.new

field_to_search = ARGV[0]
search_term = ARGV[1]

results = store.search(field_to_search, search_term)

formats = ["CD", "TAPE", "VINYL"]

results.each do |result|
  puts
  puts "Artist: #{store.inventory[result]["artist"]}"
  puts "Album: #{store.inventory[result]["title"]}"
  puts "Released: #{store.inventory[result]["release_year"]}"
  formats.each do |format|
    if store.inventory[result].key?(format)
      if store.inventory[result][format] > 0
        puts "#{format}(#{store.inventory[result][format]}): #{result}-#{format[0]}"
      end
    end
  end
end   