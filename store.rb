require 'json'
require 'erb'

# Maintains inventory and is responsible for saving and loading from disk.
# Also responsible for purchasing and other store related actiities.
class Store
  attr_reader :inventory

  def initialize
    @inventory = {}
    inventory_from_file = File.read('inventory.json')
    @inventory = JSON.parse(inventory_from_file)
  end

  def add_inventory(album_hash)
    # build album
    # TODO: refactor so we don't need album class anymore?
    album = Album.new(album_hash[:artist], album_hash[:title],
                      album_hash[:format], album_hash[:release_year],
                      album_hash[:quantity])

    # add it to inventory
    # first check if we already have this album
    # if we do, check if we have the format
    # if we do, just update quantity.
    # if we don't, add in a new format
    # if we don't even have the album, add it in!
    if @inventory[album.uid] 
      if @inventory[album.uid].key?(album.format)
        @inventory[album.uid][album.format] += album.quantity
      else
        @inventory[album.uid][album.format] = album.quantity        
      end
    else
      @inventory[album.uid] = {:title => album.title, :artist => album.artist,
        :release_year => album.release_year, "#{album.format}" => album.quantity}
    end
  end

  def save_inventory
    inventory_file = File.new('inventory.json', 'w')
      inventory_file.write(@inventory.to_json)
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

    formats = ["VINYL", "CD", "TAPE"]
    
    uid = selector.split('-')[0]
    format = selector.split('-')[1]

    case format
    when "V"
      if @inventory[uid]["VINYL"] > 0
        @inventory[uid]["VINYL"] -= 1
        puts "Removed 1 vinyl of #{@inventory[uid]["title"]} by #{@inventory[uid]["artist"]}"
      end
    when "C"
      if @inventory[uid]["CD"] > 0
        @inventory[uid]["CD"] -= 1
        puts "Removed 1 cd of #{@inventory[uid]["title"]} by #{@inventory[uid]["artist"]}"
      end
    when "T"
      if @inventory[uid]["TAPE"] > 0
        @inventory[uid]["TAPE"] -= 1
        puts "Removed 1 tape of #{@inventory[uid]["title"]} by #{@inventory[uid]["artist"]}"
      end
    else
      puts "invalid format"
    end
  end
end
