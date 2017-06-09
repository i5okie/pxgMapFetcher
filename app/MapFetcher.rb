require 'yaml'
require_relative 'device'
require_relative 'site'
require_relative 'support'

module MapFetcher
  include Support
  include Site
    
  def initialize()
    @@sites = []
  end
    
  def sites
    @@sites
  end
    
  def updateSites
    @@sites = []
    Dir.glob('./sites/*.yml') do |config|
      site = YAML.load_file(config)
      @@sites.push Site.new(site)
    end
  end
  
  def startup
    puts "-----------------------------------------"
  end
  
end