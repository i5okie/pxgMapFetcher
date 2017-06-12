
class Device
  include Support

  def initialize(name, ip, url_endpoint)
    @name = name
    @ip = ip
    @url = "http://#{ip}/#{url_endpoint}"
    @username = ""
    @password = ""
  end
  
  attr_accessor :name, :ip, :url, :username, :password
end