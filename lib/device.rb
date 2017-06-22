class Device
  include Support

  # Device.new   only require name, ip, and last portion of the url for fetching register map csv's
  def initialize(name, ip, url_endpoint)
    @name = name
    @ip = ip
    @url = "http://#{ip}/#{url_endpoint}"
    @username = ""
    @password = ""
  end

  # Create 'master' csv file, process downloaded csv files into one while skipping some registers
  def fetchMaps(uids, savepath, skiplist)
    master = "#{savepath}/#{@name}_#{@ip}_register-map.csv"
    # Create master device csv file
    begin
      CSV.open(master, 'w') do |row|
        scount = 0
        icount = 0

        # Insert header row
        row << ["Parameter Name","Display Name","uid","Base Address (0-based)","Discrete","Units","Type","Size (bytes)","Is Timestamp","Bit Offset","Swap Bytes","Swap Words","Divider","Multiplier","Date Spec","Alarm On False","Writable","Possible Values"]
        puts
        puts "#{' '*(name.length+1)}Fetching individual register maps for Unit IDs: "
        print "#{' '*(name.length+1)}"
        raise "Empty UIDS" if uids.empty?

        # Iterate over each uid
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
              scount += 1
              next
            else
              contents.each do |r|
                r.insert(2, uid)  # add uid field before the register address field
                icount += 1

                # filter out skipped
                if skiplist.include?(r[1])
                  scount += 1
                  next
                else
                  row << r
                end
              end
              PrintLine.done(contents.count.to_s)
            end
          end
          print "; "
        end
        puts "\n#{' '*(name.length+1)}Saved: #{master.green}"
        print "#{' '*(name.length+1)}"
        if (icount-scount) <= 1000
          print "Total data points: #{(icount-scount).to_s.green}"
        else
          print "Total data points: #{(icount-scount).to_s.yellow}"
        end
        print "  Skipped: #{scount.to_s.green}\n"
      end
    rescue => e
      strace(e,"Something happened with fetching this file")
    end
  end

  # Check if device is reachable on the network, returns boolean true or false
  def up?
    check = Net::Ping::WMI.new(@ip) if OS.windows?
    check = Net::Ping::TCP.new(@ip) if OS.linux? || OS.mac?
    check.ping?
  end

  attr_accessor :name, :ip, :url, :username, :password, :skiplist
end
