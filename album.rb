require 'json'
require 'erb'

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

  def render
    @template = File.read("album_template.erb")
    ERB.new(@template).result(binding)
  end

end