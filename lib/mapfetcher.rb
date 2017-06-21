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

  # facilitate creation of folder structure and copying example files only on first run
  def self.trSetup
    if File.exist?("./version")

    else
      self.startup
      puts
      puts "      First Run".white.on_green
      File.open("./version", "w") do |line|
        line.puts "Version 1.1.6"
      end
      FileUtils::mkdir_p("./sites")
      FileUtils::mkdir_p("./data")
      FileUtils::cp("#{@@runPath}/templates/example_site.yml",'./sites/')
      FileUtils::cp("#{@@runPath}/templates/example_site.csv",'./sites/')
      puts "  - Edit site definition files and populate device lists -  "
      puts "  - Run this again when done -"
      puts " ...exiting"
      exit
    end
  end

  def self.sites
    @sites
  end

  # Read 'site definition files' (yml files), process and populate
  # 'sites' array with Site objects
  def self.updateSites
    @sites = []
    PrintLine.updating('Sites')
    begin
      Dir.glob('./sites/*.yml') do |config|
        s = Site.new( YAML.load_file(config) )
        FileUtils::mkdir_p("./data/#{s.name.upcase}")
        sites.push s
        raise "No sites found".red if @sites.length < 1
      end
      print "    Found (#{@sites.count.to_s.white}): "
      @sites.each do |s|
        print "#{s.name.upcase.green}; " unless @sites.length < 1
      end
      puts
    rescue => e
      strace(e)
      raise "Can't Rescue"
    end
  end
end
