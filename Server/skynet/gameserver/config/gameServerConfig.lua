
local ip_mine = '172.30.205.31'

local ip = ip_mine



local config = {
	listen     = {
        -- ip        = '192.168.96.156',
        ip        = ip_mine,
        port      = 6677,  
        maxclient = 1024,
    },

    user_redis = {
    	host = '127.0.0.1',--ip_mine,
    	port = 6379,
    	db   = 0,
	}
}

return config
