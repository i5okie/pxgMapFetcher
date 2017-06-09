require 'yaml'
require 'colorize'
require 'colorized_string'
require_relative 'support'
require_relative 'device'
require_relative 'site'
require_relative 'printline'


module MapFetcher
  include Support

  def self.init
    @@sites = []
    
  end
  
  def self.sites
    @@sites
  end
    
  def self.updateSites
    init
    PrintLine.updating('Sites')
    begin
      Dir.glob('./sites/*.yml') do |config|
        puts config
        site = YAML.load_file(config)
        @@sites.push Site.new(site)
      end
      if sites.length < 1
        PrintLine.error
        raise "Unkown error has occured".red
      else
        PrintLine.done 
        puts "Found:"
        sites.each do |s|
          print "Site: #{s.name}   "
        end
      end
    rescue Exception => e 
      puts "An error has occured".red
      puts e.message
    end
  end
  
  def self.startup
    PrintLine.startup
    updateSites
  end
  
end