require 'smarter_csv'
require 'uri'
require 'net/http'
require 'net/http/digest_auth'

module Support
  def downloadFile(url, credentials)
    digest_auth = Net::HTTP::DigestAuth.new
    uri = URI.parse url
    uri.user = credentials['username']
    uri.password = credentials['password']

    # Requesting the authentication header
    h = Net::HTTP.new uri.host, uri.port
    req = Net::HTTP::Get.new uri.request_uri
    res = h.request req
    auth = digest_auth.auth_header uri, res['www-authenticate'], 'GET'

    # Create new request with authorization header
    req = Net::HTTP::Get.new uri
    req.add_field 'Authorization', auth
    res = h.request req
    yield res.body
  end
  
  def updateDevices(site)
    dlist = SmarterCSV.process(site.devicesfile)
    devices = site.devices
    dlist.each do |d|
      curdev = Device.new(d[:name],d[:ip],site.endpointurl)
      curdev.username = site.credentials['username']
      curdev.password = site.credentials['password']
      devices.push curdev
      PrintLine.done
    end
  end
end