require 'json'
require 'erb'
require 'yaml'

# Maintains inventory and is responsible for saving and loading from disk.
# Also responsible for purchasing and other store related actiities.
# 
# The structure of the @inventory variable is a hash with the main key being 
# the unique id for each album and each value associate with that key being an array
# where the first element is the album and the remaining elements are stock items.

class Store
  attr_reader :inventory

  DATA_FILE = 'inventory.yaml'

  def initialize
    @inventory = {}
    inventory_from_file = File.read(DATA_FILE)
    @inventory = YAML::load(inventory_from_file)
  end

  def add_inventory(supplier_album_hash)
    album = Album.new(supplier_album_hash[:artist], supplier_album_hash[:title], 
                      supplier_album_hash[:release_year])

    stock_item = StockItem.new(album.uid, supplier_album_hash[:format], supplier_album_hash[:quantity])

    if @inventory.has_key? (album.uid)
      existing_stock_item = @inventory[album.uid].find {|x| x.format == stock_item.format}
      if existing_stock_item
        existing_stock_item.quantity += stock_item.quantity
      else
        @inventory[album.uid] << stock_item
      end
    else
      @inventory[album.uid] = [album, stock_item]
    end
  end

  def save_inventory
    inventory_file = File.new(DATA_FILE, 'w')
    inventory_file.write(YAML::dump(@inventory))
    inventory_file.close
  end

  # Put the albums into an array if they match the search
  # TODO: Error checking on incorrect field
  def search(field, term)
    results = []
    self.inventory.each do |key, value|


      # binding.pry


      results
      results << value[0] if value[0].instance_variable_get(field).downcase =~ /#{Regexp.quote(term.downcase)}/
    end
    results
  end

  def report(albums)
    albums.each do |album|
      stock_items = @inventory[album.uid][1..-1]
      puts album.render
      stock_items.each do |stock_item|
        puts stock_item.render
      end
    end
  end

  def purchase(selector)
    @inventory.each do |key, value| 
      value[1..-1].each do |stock| 
        if stock.id == selector 
          stock.quantity -= 1
          puts "Removed 1 #{stock.format} of #{value[0].title} by #{value[0].artist}"
        end
      end 
    end
  end
end
