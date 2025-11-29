# gems
require 'net/ftp'
require 'logger'
require 'dotenv/load'
require 'ox'
require 'json'

#classes
require_relative '../lib/salsify/ftp'
require_relative '../lib/salsify/xml_parser'
require_relative '../lib/salsify/salsify_api'

if __FILE__ == $0
  # --- FTP download ---
  ftp_client = SalsifyConnect::FtpClient.new(
    host: ENV['FTP_SERVER'],
    user: ENV['FTP_USER'],
    password: ENV['FTP_PW']
  )
  remote_file = 'products.xml'
  local_file = ftp_client.download(remote_file)
  puts "Downloaded XML to: #{local_file}"

  # --- XML parsing ---
  json_file = 'products.json'
  XmlParser.parse(local_file, json_file)
  puts "Parsed products and saved to #{json_file}"

  # --- Salsify update ---
  salsify_client = SalsifySync::SalsifyClient.new
  salsify_client.upsert_product(json_file: json_file)

  puts "Finished!"
end