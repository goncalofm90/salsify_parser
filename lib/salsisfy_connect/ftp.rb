require 'net/ftp'
require 'logger'
require 'dotenv/load'

##reusable module if we wanted more than 1 connection
module SalsifyConnect
  class FtpClient
    def initialize(host: ENV['FTP_SERVER'], user: ENV['FTP_USER'], password: ENV['FTP_PW'], passive: true, logger: Logger.new($stdout))
      @host = host
      @user = user
      @password = password
      @passive = passive # safer in modern networks, firewall friendly
      @logger = logger
    end

    # downloads remote_path to the project folder and returns local path
    def download(remote_path)
      local_path = File.join(Dir.pwd, remote_path) # save in current folder
      Net::FTP.open(@host) do |ftp|
        ftp.passive = @passive
        ftp.login(@user, @password)
        @logger.info("Connected to FTP #{@host}, downloading #{remote_path}")
        ftp.getbinaryfile(remote_path, local_path)
      end
      local_path
    end
  end
end

## added a list.rb to check xml name so let's check if we are calling it from ftp.rb
if __FILE__ == $0
  ##call reusable module
  client = SalsifyConnect::FtpClient.new
  remote_file = 'products.xml' 
  local_file = client.download(remote_file)
  puts "Downloaded file to: #{local_file}"
end
