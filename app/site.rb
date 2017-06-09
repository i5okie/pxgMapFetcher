#
class Site
  attr_accessor name,
                uids,
                username,
                password,
                savedir,
                devicesfile,
                endpointurl

  include Support
  #
  def initialize(site)
    @name = site[:name]
    @uids = site[:uids]
    @username = site[:username]
    @password = site[:password]
    @savedir = site[:saveDir]
    @devicesfile = site[:devicesFile]
    @endpointurl = site[:endpointUrl]
    updateDevices(self)
  end
end
