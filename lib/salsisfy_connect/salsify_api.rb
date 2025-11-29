require 'faraday'
require 'json'
require 'logger'
require 'dotenv/load'


module SalsifySync
  class SalsifyClient
    def initialize(api_token:ENV['SALSIFY_TOKEN'], base_url:ENV['API_URL'], logger: Logger.new($stdout))
      @conn = Faraday.new(url: base_url) do |f|
        f.request :json
        f.response :logger, logger, bodies: true  
        f.adapter Faraday.default_adapter
      end
      @token = api_token
      @logger = logger
    end

    def upsert_product(product_id:'12364911_42', payload:   {
    "Item Name": "Flolion Liquoroso ba UPDATED4",
    "SKU": "12364911_42",
    "Brand": "Salillina Adega UPDATED",
    "Color": "BLUE",
    "MSRP": "9.99",
    "Bottle Size": "750mL",
    "Alcohol Volume": "0.14",
    "Description": "Flamboyantly oaked acidity with a hint of earthy notes. UPDATED"
  })
      path = "#{product_id}" 
      @logger.info("Updating product #{product_id}")
      response = @conn.patch(path) do |req|
        req.headers['Authorization'] = "Bearer #{@token}"
        req.headers['Content-Type'] = 'application/json'
        req.body = payload.to_json
      end
      handle_response(response)
    end

    private

    def handle_response(response)
      case response.status
      when 200..299
        JSON.parse(response.body) rescue response.body
      else
        @logger.error("Salsify API error: #{response.status} - #{response.body}")
        raise "API Error #{response.status}"
      end
    end
  end
end


client = SalsifySync::SalsifyClient.new
client.upsert_product