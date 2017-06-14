class Device < Site
  include Support

  def initialize(name, ip, url_endpoint)
    @name = name
    @ip = ip
    @url = "http://#{ip}/#{url_endpoint}"
    @username = ""
    @password = ""
  end
  
  def fetchMaps(uids, savepath)
    master = "./data/#{savepath}/#{@name}_#{@ip}_register-map.csv"
    # Create master device csv file
    CSV.open(master, 'w') do |row|
      # Insert header row
      row << ["Parameter Name","Display Name","uid","Base Address (0-based)","Discrete","Units","Type","Size (bytes)","Is Timestamp","Bit Offset","Swap Bytes","Swap Words","Divider","Multiplier","Date Spec","Alarm On False","Writable","Possible Values"]
      print " Fetching register maps for Unit IDs:"
      # Iterate over each uid
      uids.each do |uid|
        full_url = "#{url}#{uid}"
        credentials = {'username': @username, 'password': @password}
        
        # download each file, process and add to master
        downloadFile full_url, credentials do |file|
  		    file.to_s
		      contents = CSV.parse(file)
		      contents.slice!(0) # remove header row
		      contents.each do |data| # iterate over each remaining row
  		      data.insert(2, uid)  # add uid field before the register address field
  		      
		        row << data unless skip! # append modifed row to master file
		      end
		      print " #{uid.to_s.green};"
		      raise "Can't download #{full_url}"
  	    end
  	  end
  	  puts
  	  puts "          Saved: #{master.green}"
  	end
  end
  
  # 
  def skip!(data=[])
    if data==[]
      @skipaddresses
    else
      @skipaddresses.each do |s|
        if data.include? s
          true
        else
          false
        end
      end
    end
  end
  
  def up?
    # check = Net::Ping::Wmi.new(@ip)
    check = Net::Ping::WMI.new(@ip)
    check.ping?
  end
  
  attr_accessor :name, :ip, :url, :username, :password
end