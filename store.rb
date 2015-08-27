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
    # Do we have this album already?
    # If we do, use it.
    # If we don't, make a new album, stock_item, and put it in the inventory
    album = Album.new(supplier_album_hash[:artist], supplier_album_hash[:title], 
                      supplier_album_hash[:release_year])
    stock_item = StockItem.new(album.uid, supplier_album_hash[:format], supplier_album_hash[:quantity])

    # TODO: refactor into add_stock_item
    # if @inventory.has_key? (album.uid)
    #   # album already exists, now add stock_item
    #   added = false

    #   if @inventory[album.uid].count > 1

    #     @inventory[album.uid][1..-1].each do |existing_stock_item|

    #       if existing_stock_item["id"] == stock_item.id
    #         existing_stock_item[quantity] += stock_item.quantity
    #         added = true
    #       end
    #     end

    #     if added == false
    #       # then add new stock item to the inventory hash array
    #       @inventory[album.uid] << stock_item
    #     end
    #   end

    # else 
    #   # otherwise, this is a new album and new stock items, add them in!
    #   @inventory[album.uid] = [album, stock_item]
    # end
    @inventory[album.uid] = [album, stock_item]
  end

  def save_inventory
    binding.pry


    puts "bsldf"
    inventory_file = File.new(DATA_FILE, 'w')
    inventory_file.write(YAML::dump(@inventory))
    inventory_file.close
  end

  # TODO: Error checking on incorrect field
  def search(field, term)
    results = []
    self.inventory.each do |key, album|
      if album[field].downcase =~ /#{Regexp.quote(term.downcase)}/
        results << key
      end
    end
    results
  end

  def purchase(selector)
    uid = selector.split('-')[0]
    format = selector.split('-')[1]

    case format
    when 'V'
      if @inventory[uid]['VINYL'] > 0
        @inventory[uid]['VINYL'] -= 1
        puts "Removed 1 vinyl of #{@inventory[uid]['title']} by #{@inventory[uid]['artist']}"
      end
    when 'C'
      if @inventory[uid]['CD'] > 0
        @inventory[uid]['CD'] -= 1
        puts "Removed 1 cd of #{@inventory[uid]['title']} by #{@inventory[uid]['artist']}"
      end
    when 'T'
      if @inventory[uid]['TAPE'] > 0
        @inventory[uid]['TAPE'] -= 1
        puts "Removed 1 tape of #{@inventory[uid]['title']} by #{@inventory[uid]['artist']}"
      end
    else
      puts 'invalid format'
    end
  end
end
