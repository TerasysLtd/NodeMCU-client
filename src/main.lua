
-- local config has priority over generic
if file.exists("config.lua.local")
  then dofile("config.lua.local")
  else dofile("config.lua")
end

dofile("wifi_connect.lc")

-- take measurement every 1 minutes
cron.schedule("* * * * *", function(e)
  print("Cron running measurement.")
  local run = require("periodic_work")
  run.periodic()
end)

-- every day @ 2:22
cron.schedule("22 2 * * *", function(e)
  print("Cron clock sync.")
  local clock = require("ntp-clock")
  clock.sync()
end)
