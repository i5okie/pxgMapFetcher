class Site
  include Support
  
  def initialize(site)
    begin
      @name = site[:name]
      @uids = site[:uids]
      @username = site[:username]
      @password = site[:password]
      @savepath = "./data/#{@name}"
      @devicesfile = site[:devicesFile]
      @endpointurl = site[:endpointUrl]
      @skiplist = site[:skipRegisters]
      @devices = []
    rescue => e
      puts e.message
      strace(e)
    end
  end
  
  # Read site definition files from ./sites directory
  def updateDeviceList
    @devices = []
    PrintLine.updating('Devices',@name)
    begin
      dlist = SmarterCSV.process("./sites/#{@devicesfile}")
      dlist.each do |d|
        curdev = Device.new(d[:name],d[:ip],@endpointurl)
        curdev.username = @username
        curdev.password = @password
        @devices.push curdev
      end
      print "    Found: "
      puts "#{@devices.count.to_s.green} devices"
    rescue => e
      strace(e,"Failed to get list of devices")
    end
  end  
  
  # Check if device is reachable, call fetchMaps method on each device in all sites.
  def fetchMaps
    print "Downloading Register Maps for #{@name.upcase} with uids: ".black.on_white
    @uids.each {|u| print "#{u}; ".black.on_white}; puts
    begin
      @devices.each do |d| 
        print "Device: #{d.name.magenta} IP: #{d.ip.cyan} #{' ' * 10}".on_black
        if d.up?
          PrintLine.done ' up '
          d.fetchMaps(@uids, @savepath, @skiplist)
        else
          PrintLine.error ' down '
          puts
        end
      end
    rescue => e
      puts
      strace(e, 'Failed to fetch maps from all devices')
    end
  end
  
  attr_reader :name, :uids, :username, :password, :devicesfile, :endpointurl, :devices, :skiplist
end