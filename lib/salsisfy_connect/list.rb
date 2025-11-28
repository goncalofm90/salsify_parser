require 'net/ftp'
require 'logger'
require 'tempfile'
require 'dotenv/load'
require_relative 'ftp' 

client = SalsifyConnect::FtpClient.new

# script to check what's in the ftp
class SalsifyConnect::FtpClient
  def list_files(path = '.')
    Net::FTP.open(@host) do |ftp|
      ftp.passive = @passive
      ftp.login(@user, @password)
      @logger.info("Listing files in #{path}")
      ftp.nlst(path).each { |f| puts f }
    end
  end
end


client.list_files('.')
