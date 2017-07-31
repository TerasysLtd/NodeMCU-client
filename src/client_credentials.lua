-- _G.cjson = sjson

local function create_json_cred ()
    local data = {}
    data.mac = wifi.sta.getmac()
    return(sjson.encode(data))
end

local function prepare_post (server, url, json_s)
    local json_s_length = string.len(json_s)
    local post_s = "POST " .. url .. " HTTP/1.1\r\n"
            .. "Host: " .. server .. "\r\n"
            .. "Accept: */*\r\n"
            .. "User-Agent: Mozilla/4.0 (compatible; nodemcu esp8266 Lua;)\r\n"
            .. "Connection: close\r\n"
            .. "Content-Length: "..json_s_length.."\r\n"
            .. "Content-Type: application/json\r\n\r\n"
            .. json_s
    return(post_s)
end

local function parse_response(response)
     local x=response:find("\n")
     local code, text = string.match(response:sub(10,x-1), "(%d+) (%a+)")
     x=response:find("\r\n\r\n")
     local key=response:sub(x+4)
     return code, text, key
end

local function post_json_cred (server, url, json_s)
    local sk = tls.createConnection(net.TCP,1)
    sk:on("connection", function(conn)
        print("--connected")
        local post_s = prepare_post(server, url, json_s)
        print("--sending credentials: " .. json_s)
        conn:send(post_s)
    end )
    sk:on("sent", function(conn, c)
        print("--sent")
    end)
    sk:on("receive", function(conn, c)
      local code, text, key = parse_response(c)
      print("--received: " .. code .. ", " .. text .. ", auth key: " .. key)
      mykey=key
      conn:close()
    end)
    sk:on("disconnection", function(conn)  print("--disconnected") end )
    sk:connect(port,server)
end

function acquire_credentials()
    local json_cred = create_json_cred()
    post_json_cred(server, url_cred, json_cred)
end

return { acquire = acquire_credentials }
