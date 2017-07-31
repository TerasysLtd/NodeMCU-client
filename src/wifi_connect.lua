----------------------------------------------
--------pls note that the tables are initiated with dummy wifi credentials that are not available.
--------the content of this table will be replaced by new credentials on successful connection to a router.
--------------------------------------------------------------

--- Connect to the wifi network ---
print("Connecting to WiFi access point...")
wifi.setmode(wifi.STATIONAP)
  
       ----initiate counter
       counter = 0
        ---initiate the configuration of the station mode with terasys credentials
            wifi.sta.config(terasys)
             tmr.alarm(1, 1000, tmr.ALARM_SEMI, function()
               counter = counter + 1
               ----try to connect to Router saved in terasys table
                if counter < 20 then
                  if wifi.sta.getip() == nil then
                    print("NO IP yet! Keep trying to connect to " .. terasys.ssid)
                    tmr.start(1) -- restart
                   else
                      print("Connected to " .. terasys.ssid )
                     end
                     ---if the connection to router in terasys table fails, ----try to connect to Router saved in dapo's table
                  elseif counter < 40 then
                    wifi.sta.config(dapo)
                    if wifi.sta.getip() == nil then
                      print("NO IP yet! Keep trying to connect to " .. dapo.ssid)
                      tmr.start(1) -- restart
                    else
                      print("Connected to " .. dapo.ssid)
                    end
                    ---if the connection to router in dapo's table fails, ----try to connect to Router saved in deji's table
                  elseif counter < 60 then
                      wifi.sta.config(deji)
                      if wifi.sta.getip() == nil then
                        print("NO IP yet! Keep trying to connect to " .. deji.ssid)
                        tmr.start(1) -- restart
                      else
                        print("Connected to " .. deji.ssid)
                      end
                      ---if the connection to router in deji's table fails, ----try to connect to Router saved in gboyega's table
                  elseif counter < 80 then
                      if gboyega.ssid ~= nil then 
                        wifi.sta.config(gboyega)
                      end
                        if wifi.sta.getip() == nil then
                          print("NO IP yet! Keep trying to connect  " .. gboyega.ssid )
                          tmr.start(1) -- restart
                        else
                          print("Connected to " .. gboyega.ssid)
                      end
                  --     -------------if they all fails, start the wifi manager
                  else
                    print("Out of options. Starting the WiFi Manager")
                     captivePortal()

                  end

              end)

     

-------------function to start the wifi manager
             function captivePortal()
                 enduser_setup.start(
                    function()
                      print("End Module Connected")
                      -- if wifi.sta.getip() == nil then
                      --   searchNetwork()
                      -- end
                    end,
                    function(err, str)
                      print("enduser_setup: Err #" .. err .. ": " .. str)
                    end,
                    print -- Lua print function can serve as the debug callback
                  );

                 -- local count =0
                 -- tmr.alarm(2, 1000, tmr.ALARM_SEMI, function()
                 --    count = count + 1
                 --   ----try to connect to Router saved in tables
                 --    if counter < 60 then
                 --      if wifi.sta.getip() == nil then searchNetwork() 
                 --          tmr.start(1) -- restart
                 --      end
                 --    end
                 --  end)
              end


              -- ---------function to replace the dummy data in the tables if the wifi credentials do not exist in the table before.
              -- function populateTable( )
              --         -- ---Get the ssid and passord of AP connected to
              --         ssid, pwd, bssid_set, bssid = wifi.sta.getdefaultconfig()
              --         print("\nCurrent Station configuration:\nSSID : "..ssid .."\nPassword  : "..pwd) ---------------this is for debuging purpose

              --   if  terasys[1]~= ssid then  ------------test if ssid is empty or if it exist
              --     if terasys[2] ~= pwd then                      ------------test if the ssid has the same password
              --        table.remove(terasys,1 )                         -------save the credentilas if they dont exist
              --         table.insert(terasys,1, ssid)
              --         table.remove(terasys,2 )                         -------save the credentilas if they dont exist
              --         table.insert(terasys,2, pwd)
              --           print(terasys[1])
              --           print(terasys[2])
              --           terasys001.ssid= terasys[1]
              --           terasys001.pwd= terasys[2]
              --           terasys001.save=true
              --           print(terasys001.ssid)
              --           print(terasys001.pwd)
              --     end
              --   -- elseif dapo.ssid == nil or dapo.ssid== ssid then
              --   --     if dapo.pwd ~=pwd  then
              --   --       dapo.ssid= ssid
              --   --       dapo.pwd= pwd  
              --   --     end
              --   --     print(dapo.ssid)
              --   --     print(dapo.pwd)

              --   -- elseif deji.ssid == nil  or deji.ssid == ssid then
              --   --     if deji.pwd ~= pwd then
              --   --       deji.ssid=ssid
              --   --       deji.pwd=pwd 
              --   --     end
              --   --     print(deji.ssid)
              --   --     print(deji.pwd)
              --   -- elseif wifi1.ssid== nil or wifi1.ssid == ssid then
              --   --     if wifi1.pwd~= pwd then
              --   --       wifi1.ssid= ssid
              --   --       wifi1.pwd=pwd 
              --   --     end
              --   --     print(wifi1.ssid)
              --   --     print(wifi1.pwd)

              --   -- elseif wifi2.ssid== nil then
              --   --     if wifi2.pwd ~= pwd then
              --   --      wifi2.ssid= ssid
              --   --       wifi2.pwd= pwd 
              --   --     end
              --   --     print(wifi2.ssid)
              --   --     print(wifi2.pwd)

              --   else 
              --     print ("All the table is populated")
              --   end
              -- end
              

-- --------------------------------------------------------------

tmr.create():alarm(2000, tmr.ALARM_AUTO, function(cb_timer)
    if wifi.sta.getip() == nil then
        print("Waiting for IP address...")
    else
        cb_timer:unregister()
        print("WiFi connection established " )
        tmr.create():alarm(1, tmr.ALARM_SINGLE, function()
          local clock = require("ntp-clock")
          clock.sync()
        end)
    end
end)

tmr.create():alarm(10000, tmr.ALARM_AUTO, function(cb_timer)
    if mykey == nil and wifi.sta.getip() ~= nil and rtctime.get() > 1000000 then
          print("Acquiring auth keys.")
          local cred = require("client_credentials")
          cred.acquire()
    elseif mykey ~= nil then
        cb_timer:unregister()
    end
end)


