class Site
  include Support

  # Site.new(site hash read from site difinition file (yml file)
  def initialize(site)
    begin
      @name = site[:name]
      @uids = site[:uids]
      @username = site[:username]
      @password = site[:password]
      @savedir = site[:name]
      @savepath = "./data/#{@name}"
      @devicesfile = site[:devicesFile]
      @endpointurl = site[:endpointUrl]
      @skiplist = []
      @devices = []
      site[:skipRegisters].each do |s|
        if !s.instance_of? String
          @skiplist.push s.to_s
        else
          @skiplist.push s
        end
      end
    rescue => e
      puts e.message
      strace(e)
    end
  end

  # Read list of devices from csv file specified in yml SDF
  # Populate 'devices' array with device objects
  def updateDeviceList
    @devices = []
    PrintLine.updating('Devices',@name.upcase)
    begin
      dlist = SmarterCSV.process("./sites/#{@devicesfile}")
      dlist.each do |d|
        curdev = Device.new(d[:name],d[:ip],@endpointurl)
        curdev.username = @username
        curdev.password = @password
        curdev.skiplist = @skiplist
        @devices.push curdev
      end
      print "    Found: "
      puts "#{@devices.count.to_s.green} devices"
    rescue => e
      strace(e,"Failed to get list of devices")
    end
  end

  # Iterate through list of all devices and fetch and process csv files
  # Check if device is reachable on the network before calling
  # 'fetchMaps' method on each device which actually does most of the work
  def fetchMaps
    print "Downloading Register Maps for #{@name.upcase} with uids: ".black.on_white
    @uids.each {|u| print "#{u}; ".black.on_white}; puts
    begin
      savepath = "./#{@savedir}"
      @devices.each do |d|
        print "Device: #{d.name.magenta} IP: #{d.ip.cyan} #{' ' * 10}".on_black
        if d.up?
          PrintLine.done " up "
          d.fetchMaps(@uids, savepath)
        else
          PrintLine.error ' downn '
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
