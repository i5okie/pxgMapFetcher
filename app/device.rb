
class Device
  include Support

  def initialize(name, ip, url_endpoint)
    @@name = name
    @@ip = ip
    @@url_endpoint = url_endpoint
  end

  def name
    @@name
  end

  def ip
    @@ip
  end

  def url
    @@url = "http://#{@@ip}/#{@@url_endpoint}"
    @@url
  end

  def username
    @@username
  end

  def password
    @password
  end
end