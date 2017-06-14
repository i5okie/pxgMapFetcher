class Site
  include Support
  
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
      @skipaddresses = site[:skipRegisters]
      @devices = []
    rescue => e
      puts e.message
      strace(e)
    end
  end
  
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
  
  def fetchMaps
    print "Downloading Register Maps for #{@name.light_green} with uids: "
    @uids.each {|u| print "#{u.to_s.light_green}; "}; puts
    begin
      savepath = "./#{@savedir}"
      @devices.each do |d| 
        print " #{d.name.light_yellow} ".on_black
        if d.up?
          PrintLine.done 'Up'
          d.fetchMaps(@uids, savepath)
        else
          PrintLine.error 'Down'
        end
      end
    rescue => e
      puts
      strace(e, 'Failed to fetch maps from all devices')
    end
  end
  
  attr_reader :name, :uids, :username, :password, :devicesfile, :endpointurl, :devices
end