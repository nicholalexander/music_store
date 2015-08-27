require 'pry'
require './store.rb'
require './album.rb'
require './stock_item.rb'

store = Store.new

field_to_search = "@" + ARGV[0]
search_term = ARGV[1]

results = store.search(field_to_search, search_term)
store.report(results)
