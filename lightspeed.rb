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

  def get(url)
    parse(url, 'get')
  end

  def delete(url)
    parse(url, 'delete')
  end

  def parse(url, method)
    JSON.parse make_request(url, method).body
  end

  def make_request(url, method)
    method_name = "net_#{method}"
    @client.start do |http|
      req = send(method_name, "/API/Account/#{@id}/#{url}")
      req.basic_auth(@key, 'apikey')
      http.request(req)
    end
  end

  def net_get(url)
    Net::HTTP::Get.new(url)
  end

  def net_delete(url)
    Net::HTTP::Delete.new(url)
  end
end

l = Lightspeed.new
puts 'see your permissions:  JSON.parse l.req_controls.body'
puts 'try:  l.get "Category.json"'
puts 'try:  l.get "Item.json"'
puts 'try:  l.get "Item/2.json"'
puts 'try:  l.get "Image.json"'
puts 'try:  l.get "Item.json?tax=true"'
puts 'try:  l.get "InventoryCountItem.json?itemID=6"'
puts 'try:  l.get "Item/6.json?load_relations=all"'
puts 'try:  l.delete "Item/6.json"'
binding.pry
