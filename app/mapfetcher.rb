require 'yaml'
require 'colorize'
require 'colorized_string'
require './app/support'
require './app/device'
require './app/site'
require './app/printline.rb'


module MapFetcher
  extend Support
  
  def self.startup
    @sites = []
    PrintLine.startup
    self.updateSites
  end
  
  def self.sites
    @sites
  end

  def self.updateSites
    @sites = []
    PrintLine.updating('Sites')
    begin
      print "    Found: "
      Dir.glob('./sites/*.yml') do |config|
        site = YAML.load_file(config)
        s = Site.new(site)
        sites.push s
        print "#{s.name.green}" unless @sites.length < 1
        print "," unless @sites.length ==1
        raise "No sites found".red if @sites.length < 1
      end
      puts
    rescue => e
      puts e.message
      strace(e)
      raise "Can't Rescue"
    end
  end

end