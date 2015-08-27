require 'json'
require 'erb'

# Albums in the Store inventory and how they are written to disk
class Album
  attr_reader :uid, :artist, :title, :format, :release_year, :quantity

  def initialize(artist, title, release_year)
    digest_string = (artist + title + release_year).gsub(/\s+/, '')
    @uid = Digest::MD5.hexdigest(digest_string)
    @artist = artist
    @title = title
    @release_year = release_year
  end

  def to_json (options = {})
    { 'uid' => @uid, 'artist' => @artist, 'title' => @title,
      'release_year' => @release_year }.to_json
  end
    
  def render
    @template = File.read("album_template.erb")
    ERB.new(@template).result(binding)
  end

end