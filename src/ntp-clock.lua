
function do_clock_sync ()
      sntp.sync(ntpserver,
      function(sec, usec, server, info)
        print('Synced to epoch', sec, 'from server', server)
        local tm = rtctime.epoch2cal(rtctime.get())
        print(string.format("Now: %04d/%02d/%02d %02d:%02d:%02d", tm["year"], tm["mon"], tm["day"], tm["hour"]+1, tm["min"], tm["sec"]))
      end,
      function()
        print('Clock sync failed, retrying!')
        tmr.create():alarm(1000, tmr.ALARM_SINGLE, function()
          do_clock_sync()
        end)
      end
    )
end

return { sync = do_clock_sync }

