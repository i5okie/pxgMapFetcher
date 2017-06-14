require 'colorize'
require 'colorized_string'

module PrintLine
  def self.startup
    puts "-----------------------------------------".blue
    puts "     pxgMapFetcher -- MultiSite          ".on_black
    puts "-----------------------------------------".blue
  end

  def self.updating(what, subj='')
    print "Updating #{what.green}"
    print "  for #{subj.green}" unless subj==''
  end

  def self.loading(what)
    puts "Loading:  #{what}"
  end

  def self.done(msg="Done")
    print '['
    print msg.green
    puts ']'
  end

  def self.error(err='Error')
    print '['
    print err.red
    puts ']'
  end
end