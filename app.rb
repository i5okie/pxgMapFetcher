require_relative './lib/mapfetcher.rb'

MapFetcher.trSetup
MapFetcher.startup
MapFetcher.sites.each do |s|
  s.updateDeviceList
  s.fetchMaps
end