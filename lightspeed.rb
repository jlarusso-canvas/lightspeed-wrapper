require 'net/https'
require 'json'
require 'pry'

class Lightspeed
  def initialize
    @id = ENV['LIGHTSPEED_ID']
    @key = ENV['LIGHTSPEED_KEY']

    @client = Net::HTTP.new('api.merchantos.com', 443)
    @client.use_ssl = true
  end

  def fetch(url)
    JSON.parse make_request(url).body
  end

  def make_request(url)
    @client.start do |http|
      req = net_get("/API/Account/#{@id}/#{url}")
      req.basic_auth(@key, 'apikey')
      http.request(req)
    end
  end

  def req_controls
    @client.start do |http|
      req = net_get("/API/Controls.json")
      req.basic_auth(@key, 'apikey')
      http.request(req)
    end
  end

  def net_get(url)
    Net::HTTP::Get.new(url)
  end
end

l = Lightspeed.new
puts 'see your permissions:  JSON.parse l.req_controls.body'
puts 'try:  l.fetch("Category.json")'
puts 'try:  l.fetch("Item.json")'
puts 'try:  l.fetch("Item/2.json")'
puts 'try:  l.fetch "Image.json"'
puts 'try:  l.fetch "Item.json?tax=true"'
puts 'try:  l.fetch "InventoryCountItem.json?itemID=6"'
puts 'try:  l.fetch "Item/6.json?load_relations=all"'
binding.pry
