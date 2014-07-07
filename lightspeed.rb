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

  def net_get(url)
    Net::HTTP::Get.new(url)
  end
end

l = Lightspeed.new
puts 'try:  l.fetch("Category.json")'

binding.pry
