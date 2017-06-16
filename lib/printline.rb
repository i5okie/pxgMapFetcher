require 'colorize'
require 'colorized_string'

# Utility methods to facilitate some humanization to the screen output
module PrintLine
  def self.startup
    puts "#{'-' * 80}".blue
    puts center("pxgMapFetcher -- MultiSite").on_black
    puts "#{'-' * 80}".blue
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
    print ']'
  end

  def self.error(err='Error')
    print '['
    print err.red
    print ']'
  end

  def self.center(text)
    le = text.length
    if ((80 - le) % 2)==0
      sp = (80 - le) / 2
    else
      sp = (80 - le) % 2
    end
    "#{' ' * sp}#{text}"
  end
end
