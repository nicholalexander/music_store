require 'pry'
require './store.rb'
require './album.rb'
require './stock_item.rb'

uid = ARGV[0]

store = Store.new

store.purchase(uid)
store.save_inventory