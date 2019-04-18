NodeMCU Logger
=====================================

This is Lua code that runs on a NodeMCU and periodically reports
reading from the connected sensor(s) to TerasysHUB  server.

Needed hardware
---------------
ESP8266 (in any form, basically) with Lua firmware, properly interconnected
with supported sensors. NodeMCU is an ESP8266 board variant equipped with
an additional hardware that makes it easy to connect with micro USB port
for power, communication and resetting/flashing the unit with serial
control lines (DTR, RTS).
By default boards run AT or lua firmware. For this project firmware with
non-default modules is needed.

For details on attaching the sensors, flashing the firmware and copying
the code to the unit, see [hardware documentation](doc/Hardware.md).

Software configuration
----------------------
Before uploading the code to the unit, user should configure
site-specific data and sensor logic.
For more details, please see [configuration documentation](doc/Configuration.md).

Documentation
-------------
Further documentation is in the `doc` folder.
