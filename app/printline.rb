require 'colorize'
require 'colorized_string'

module PrintLine


  def self.startup
    puts "-----------------------------------------".blue
    puts "     pxgMapFetcher -- MultiSite"
    puts "-----------------------------------------".blue
  end

  def self.updating(what)
    print "Updating: #{what}      ".yellow
  end

  def self.loading(what)
    puts "Loading:  #{what}"
  end

  def self.done
    print '['
    print 'done'.green
    puts ']'
  end

  def self.error
    print '['
    print 'error'.red
    puts ']'
  end
end