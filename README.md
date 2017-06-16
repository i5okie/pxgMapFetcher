# pxgMapFetcher
---
A utility to download and compile ModBus register maps for specified uids
from APC PowerXpert Gateway Series 1000 devices.

Connects to each device, downloads specified UIDs, and combines them into a single csv file per device.

Created to submit a Device Definition File request to Schneider for DCIM package since PowerXpert Gateway Series 1000 devices do not provide complete available data via SNMP, a unique ModBus register map must be downloaded from each device where breakers and breaker assignments vary from panel to panel.

#### Build
1. Under linux:  rake package:win32

#### Quick Start:
Download release zip, then:
1. Run 'mapFetcher.bat'    (on first run it will setup directories and quit.)
2. Use 'example_site.yml' and 'example_site.csv' files to create site definition files and device list files per site
2. Rename above files as you see fit, make sure to specify correct .csv file name inside the .yml file
3. Run `mapFetcher.bat` (windows) / `./mapFetcher` (linux)


![screenshot](https://image.prntscr.com/image/YtAxjpn1Q7iTruyta3PcLQ.png)





Details:
---
The following files can be modified to achieve differet results:
+ ./sites/example_site.yml  --  Site definition file.
+                  above file is a template with included documentation.
                   Specify site name, which unit ids to download maps for,
                   and make sure to specify name of the .csv file with list
                   of devices for specific site.
                   Optionally, edit list of data points to skip. Erase default ones if needed (leave square brackets).
+ ./sites/example_site.csv --  List of devices.
+                  Populate with device name and ip address
+                  Update this list if list of devices or names changes. 
+                  Do not change column names!

---
License: MIT
