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

  def post(url, params)
    parse(url, 'post', params)
  end

  def parse(url, method, params = nil)
    JSON.parse make_request(url, method, params).body
  end

  def make_request(url, method, params = nil)
    method_name = "net_#{method}"
    @client.start do |http|
      req = send(method_name, "/API/Account/#{@id}/#{url}", params)
      req.basic_auth(@key, 'apikey')
      http.request(req)
    end
  end

  def net_get(url, params)
    Net::HTTP::Get.new(url)
  end

  def net_delete(url, params)
    Net::HTTP::Delete.new(url)
  end

  def net_post(url, params)
    puts params
    req = Net::HTTP::Post.new(url, initheader = {'Content-Type' => 'application/json'})
    req.body = params.to_json
    req
  end
end

sale = {}
sale["completed"] = true
sale["Shop"] = {}
sale["Shop"]["shopID"] = "11"
sale["SaleLines"] = {}
sale["SaleLines"] = []

sale_line = {}
sale_line["itemID"] = "929"
sale_line["unitQuantity"] = "1"

sale["SaleLines"] << { "SaleLine" => sale_line }

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
puts 'try:  l.get "Item.json?limit=999"'
puts 'try:  l.post "Sale.json", sale'
binding.pry
