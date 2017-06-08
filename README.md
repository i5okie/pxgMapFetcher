# pxgMapFetcher

A utility to download and compile ModBus register maps for specified uids
from APC PowerXpert Gateway Series 1000 devices.

Connects to each device, downloads specified UIDs, and combines them into a single csv file per device.

Created to submit a Device Definition File request to Schneider for DCIM package since PowerXpert Gateway Series 1000 devices do not provide complete available data via SNMP, a unique ModBus register map must be downloaded from each device where breakers and breaker assignments vary from panel to panel.

#### Quick Start:
1. Edit config.yml (change device credentials and specify uids here)
2. Fill in devices.csv
3. Run program


Windows
---
Using TravelingRuby with Ruby v2.2.2.
Additional functionality added via batch files to create zip file after the code is run.

| Executable | Description |
| ------ | ----------- |
| fetchMaps.bat | connects to devices and downloads register maps |
| generateRequest.bat | reates a zip file 'PXG1000-RPP_MultiRequest.zip' |
| doAll.bat | fetches data then creates a zip file. |

Resulting zip file contains one CSV file per device, Schneider DDF request form, and PDF ModBus section from the PXG1000 user manual.
CSV contains UID field and all the data points, register addresses, etc that were downloaded from device.

Linux
---
`ruby app.rb` will connect to each device and save CSV file per device in the `data` folder

---

Details:
---
The following files can be modified to achieve differet results:
+ ./config.yml  --  modify this file to update username/password for
                   logging into devices, specify which csv file contains
                   list of devices with ip and baseurl addresses, specify
                   which UIDS to fetch register maps for, and which
                   folder to save files to.
+ ./devices.csv --  contains list of device names, ip addreses, and baseurls. Update this list if list of devices or names changes. Do not change columns names!

---
License: MIT
