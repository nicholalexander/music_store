require 'json'
require 'erb'

# Maintains inventory and is responsible for saving and loading from disk.
# Also responsible for purchasing and other store related actiities.
class Store
  attr_reader :inventory

  def initialize
    @inventory = {}
    @last_uid = 0
    inventory_file = File.new('inventory.json', 'r+')
    inventory_file.each_line do |line|
      album_hash = JSON.parse(line)
      album = Album.new(album_hash['uid'], album_hash['artist'],
                        album_hash['title'], album_hash['format'],
                        album_hash['release_year'],
                        album_hash['quantity'])
      @inventory[album.uid] = album
      @last_uid = album.uid if album.uid >= @last_uid
    end
    inventory_file.close
  end

  def add_inventory(album_hash)
    # build album
    album = Album.new(@last_uid + 1, album_hash[:artist], album_hash[:title],
                      album_hash[:format], album_hash[:release_year],
                      album_hash[:quantity])

    # add it to inventory
    # TODO: Check for duplicates, title casing
    @inventory[album.uid] = album
    @last_uid = album.uid
  end

  def save_inventory
    inventory_file = File.new('inventory.json', 'w')
    @inventory.each do |_key, album|
      inventory_file.puts(album.to_json)
    end
    inventory_file.close
  end

  # TODO: Error checking on incorrect field
  def search(field, term)
    results = []
    self.inventory.each do |_key, album|
      if album.instance_variable_get(field).downcase =~ /#{Regexp.quote(term.downcase)}/
        results << album
      end
    end
    results
  end

  def purchase
  end
end
