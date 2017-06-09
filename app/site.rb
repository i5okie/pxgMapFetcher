class Site
  extends Site
  include Device
  
  def initialize(site)
    @@name = site[:name]
    @@uids = site[:uids]
    @@username = site[:username]
    @@password = site[:password]
    @@savedir = site[:saveDir]
    @@devicesfile = site[:devicesFile]
    @@endpointurl = site[:endpointUrl]
  end
  
  def name
    @@name
  end
  
  def uids
    @@uids
  end
  
  def username
    @@username
  end
  
  def password
    @@password
  end
  
  def savedir
    @@savedir
  end
  
  def devicesfile
    @@devicesfile
  end
  
  def devices
    @@devices
  end
  
  def endpointurl
    @@endpointurl
  end
  
end