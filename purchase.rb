require './store.rb'
require './album.rb'
require './stock_item.rb'

# initialize
uid = ARGV[0]
store = Store.new

# purchase and save changes
store.purchase(uid)
store.save_inventory