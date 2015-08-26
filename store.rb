require 'json'

# Albums in the Store inventory and how they are written to disk
class Album
  attr_reader :uid, :artist, :title, :format, :release_year, :quantity

  def initialize(uid, artist, title, format, release_year, quantity)
    @uid = uid
    @artist = artist
    @title = title
    @format = format
    @release_year = release_year
    @quantity = quantity
  end

  def to_json
    { 'uid' => @uid, 'artist' => @artist, 'title' => @title,
      'format' => @format, 'release_year' => @release_year,
      'quantity' => @quantity }.to_json
  end
end

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

  def search
  end

  def purchase
  end
end
