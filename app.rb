require_relative './lib/mapfetcher.rb'

MapFetcher.trSetup
MapFetcher.startup
MapFetcher.sites.each do |s|
  s.updateDeviceList
  s.fetchMaps
end


# Read list of devices from csv file with IP addresses.
# print "Getting list of devices from #{cfg[:deviceList]}:"
# devices = SmarterCSV.process(cfg[:deviceList])
# puts "   found #{devices.count} devices."

# Print out some formatting.
# puts "=========================================================================="
# print "   Name  |  IP Address  |"
# cfg[:uids].each do |uid|
  # print " uid: #{uid} |"
# end
# puts

# Iterate over each device in the list
# devices.each do |d|
#
  ## Print out table entry
  # print " #{d[:name]} | #{d[:ip]} |"
  # master = "#{cfg[:targetDir]|| '.'}/#{d[:name]}_#{d[:ip]}_Register-Map.csv"
#
  ## Create master device csv file
  # CSV.open(master, 'w') do |row|
    ## Insert header row
    # row << ["Parameter Name","Display Name","uid","Base Address (0-based)","Discrete","Units","Type","Size (bytes)","Is Timestamp","Bit Offset","Swap Bytes","Swap Words","Divider","Multiplier","Date Spec","Alarm On False","Writable","Possible Values"]
#
    ## Iterate over each uid
    #cfg[:uids].each do |uid|
      #print "  "
      #url = "#{d[:baseurl]}#{uid}" # build complete url with uid from baseurl
#
      ## download file
	    #getFile url, cfg do |file|
		    #file.to_s
		    #contents = CSV.parse(file)
		    #contents.slice!(0) # remove header row
		    #contents.each do |data| # iterate over each remaining row
		      #data.insert(2, uid)  # add uid field before the register address field
		      #row << data # append modifed row to master file
		    #end
		    #print 'done'
  	  #end
      #print "  |"
    #end
    #puts
  #end
#end
#

