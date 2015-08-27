require 'json'

# StockItem handles the indivual units of stock in the store.
# In the future, we would use this to attach prices to our 
# inventory to become a profitable store!

class StockItem
  attr_accessor :format, :quantity
  attr_reader :album_id, :id

  def initialize(album_id, format, quantity)
    @album_id = album_id
    @format = format
    @quantity = quantity
    @id = Digest::MD5.hexdigest("#{album_id + format}")
  end

  def to_json (options = {})
      { 'id' => @id, 'format' => @format, 'quantity' => @quantity }.to_json
  end

end