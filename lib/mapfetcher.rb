require 'yaml'
require 'colorize'
require 'colorized_string'
require 'fileutils'
require 'smarter_csv'
require_relative './support'
require_relative './site'
require_relative './device'
require_relative './printline.rb'

module MapFetcher
  extend Support
  @@runPath = File.dirname(__FILE__)
  
  def self.startup
    @sites = []
    PrintLine.startup
    self.updateSites
  end
  
  def self.trSetup
    FileUtils::mkdir_p("./sites")
    FileUtils::mkdir_p("./data")
    FileUtils::cp("#{@@runPath}/templates/example_site.yml",'./sites/')
    FileUtils::cp("#{@@runPath}/templates/example_site.csv",'./sites/')
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
        FileUtils::mkdir_p("./data/#{s.name}")
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