class Site
  include Support
  
  def initialize(site)
    begin
      @name = site[:name]
      @uids = site[:uids]
      @username = site[:username]
      @password = site[:password]
      @savedir = site[:saveDir]
      @devicesfile = site[:devicesFile]
      @endpointurl = site[:endpointUrl]
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
      rescue "Couldn't update device list."
    rescue => e
      puts "Error when updating devices.".red
      puts e.message
      strace(e)
    end
  end  
  
  def fetchMaps
    print "Downloading Register Maps for #{@name.light_green} with uids: "
    @uids.each {|u| print "#{u.to_s.light_green}; "}; puts
    begin
      savepath = "./#{@savedir}"
      @devices.each do |d| 
        d.fetchMaps(@uids, savepath)
      end
    rescue => e
      puts
      puts e.message.white.on_cyan
      strace(e)
    end
  end
  
  attr_reader :name, :uids, :username, :password, :devicesfile, :endpointurl, :devices
end