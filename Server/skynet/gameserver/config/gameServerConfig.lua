
local ip_mine = '172.30.203.86'

local ip = ip_mine



local config = {
	listen     = {
        -- ip        = '192.168.96.156',
        ip        = ip_mine,
        port      = 6677,  
        maxclient = 1024,
    },
}

return config
