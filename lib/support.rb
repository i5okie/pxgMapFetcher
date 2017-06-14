require 'uri'
require 'net/http'
require 'net/ping'
require 'net/http/digest_auth'

module Support
  
  def downloadFile(url, credentials)
    begin
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
    rescue => e
      PrintLine.error "Timed Out" if e.message.include? "timed out"
    end
  end

  def strace(exception, msg = 'Unkown Error')
    print "\a"
    stacktrace = exception.backtrace.map do |call|
      if parts = call.match(/^(?<file>.+):(?<line>\d+):in `(?<code>.*)'$/)
        file = parts[:file].sub /^#{Regexp.escape(File.join(Dir.getwd, ''))}/, ''
        line = "#{file.cyan} #{'('.white}#{parts[:line].green}#{'): '.white} #{parts[:code].red}"
      else
        line = call.red
      end
      line
    end
    puts "#{msg.red}: #{exception.message}"
    stacktrace.each { |line| puts line }
    exit
  end
end