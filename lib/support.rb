require 'uri'
require 'net/http'
require 'net/http/digest_auth'
require 'os'
# Check if OS is linux or windows and require only the compatible module
require 'net/ping/wmi' if OS.windows?
require 'net/ping' if OS.linux? || OS.mac?

module Support

  # Downloads file with Digest Authentication, returns contents
  def downloadFile(url, username='admin', password='admin')
    begin
      digest_auth = Net::HTTP::DigestAuth.new
      uri = URI.parse url
      uri.user = username
      uri.password = password

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

  # Clean printout of exception with stacktrace
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

  # Used in dev. only to quickly output something and be visible in the stream of garbage
  def debug(msg = "")
    puts "\n\n\n"
    puts "   DEBUGGING   ".white.on_red
    puts msg
    puts "\n\n\n"
    exit
  end
end
