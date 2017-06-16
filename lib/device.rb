class Device < Site
  include Support

  # Device.new   only require name, ip, and last portion of the url for fetching register map csv's
  def initialize(name, ip, url_endpoint)
    @name = name
    @ip = ip
    @url = "http://#{ip}/#{url_endpoint}"
    @username = ""
    @password = ""
    @skiplist = []
  end

  # Create 'master' csv file, process downloaded csv files into one while skipping some registers
  def fetchMaps(uids, savepath, skipList=[])
    master = "./data/#{savepath}/#{@name}_#{@ip}_register-map.csv"
    scount = 0
    icount = 0

    # Create master device csv file
    begin
      CSV.open(master, 'w') do |row|
        # Insert header row
        row << ["Parameter Name","Display Name","uid","Base Address (0-based)","Discrete","Units","Type","Size (bytes)","Is Timestamp","Bit Offset","Swap Bytes","Swap Words","Divider","Multiplier","Date Spec","Alarm On False","Writable","Possible Values"]
        puts
        puts "#{' '*(name.length+1)}Fetching individual register maps for Unit IDs: "
        print "#{' '*(name.length+1)}"
        # Iterate over each uid
        raise "Empty UIDS" if uids.empty?
        uids.each do |uid|
          full_url = "#{url}#{uid}"
          print "#{uid.to_s.blue}: "

          # download each file, process and add to master
          downloadFile full_url do |file|
            raise "Received empty file for Unit ID #{uid}." if file.empty?
            file.to_s
            contents = CSV.parse(file)
            contents.slice!(0) # remove header row
            if contents.length == 0
              PrintLine.error('none')
              scount = scount + 1
              next
            else
              contents.each do |r|
                r.insert(2, uid)  # add uid field before the register address field
                row << r unless skip!(r)
                icount = icount + 1
              end
              PrintLine.done(contents.count.to_s)
            end
          end
          print "; "
        end
        puts "\n#{' '*(name.length+1)}Saved: #{master.green}"
        print "#{' '*(name.length+1)}"
        if icount <= 1000
          print "Total data points: #{icount.to_s.green}  Skipped: #{scount}\n"
        else
          print "Total data points: #{icount.to_s.yellow}  Skipped: #{scount}\n"
        end
      end
    rescue => e
      strace(e,"Something happened with fetching this file")
    end
  end

  # reads array of values to match against each row of incoming data
  # returns boolean true or false
  def skip!(data=[])
    scount = 0
    if data==[]
      return false
    else
      skiplist.each do |s|
        scount = scount + 1 if data.include? s
      end
    end
    if scount > 0
      return true
    else
      return false
    end
  end

  # Check if device is reachable on the network, returns boolean true or false
  def up?
    check = Net::Ping::WMI.new(@ip)
    check.ping?
  end

  attr_accessor :name, :ip, :url, :username, :password, :skiplist
end
