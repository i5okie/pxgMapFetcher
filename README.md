# pxgMapFetcher
---
**A utility download ModBus register maps from Eaton PowerXpert Gateway 1000 Series devices.**
_Tested to work with: PXG1000 and PXG2000. Should be compatible with others such as PXGX 2000, and PXG UPS cards._


The way ModBus is implemented on PXG1000 series devices requires a register map to be manually generated for each Unit ID, each its own file.
- Device itself is Unit ID 0
- Unit ID (2-17) Listing Summary data per panel
- Unit ID (18-33) Listing Lndividual breaker data per specific panel

These files have to be downloaded every time a panel configuration changes (i.e.: breaker added/removed/changed for different one).
This can be a very time consuming process. – MapFetcher will do this for you in a single step. MapFetcher goes one step further and combines all individual .csv files into a single register map per device.

Originally created to submit a Device Definition File request to Schneider for Data Center Expert (DCIM) since PowerXpert Gateway Series 1000 devices do not provide all available data via SNMP, and a unique ModBus register map must be downloaded whenever panel configuration is modified or is different from other devices. 

#### Build
1. Download / Clone repo
2. Run rake `rake package:win32` for Windows / `rake package:linux:x86` for Linux

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
