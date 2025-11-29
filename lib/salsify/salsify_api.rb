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

    def upsert_product(json_file: nil)
    if json_file
        file_contents = File.read(json_file)
        products = JSON.parse(file_contents, symbolize_names: true)

        products.each do |item|
        product_id = item[:SKU]
        payload = item

        begin
            _update_single(product_id, payload)
        rescue => e
            @logger.error("Failed to update #{product_id}: #{e.message}")
        end
        end
    else
        raise "No JSON file provided for batch update"
    end
    end

    private
    # helper 
    def _update_single(product_id, payload)
    path = "#{product_id}" 
    @logger.info("Updating product #{product_id}")
    ##patch updates only the fields we need to change so it's usually faster
    response = @conn.patch(path) do |req|
        req.headers['Authorization'] = "Bearer #{@token}"
        req.headers['Content-Type'] = 'application/json'
        req.body = payload.to_json
    end
    handle_response(response)
    end


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