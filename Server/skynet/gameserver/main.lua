local skynet    = require "skynet.manager"
--local TAG = 'main'

local max_client = 64

skynet.start(function()
	skynet.error("Server start")
	local watchdog = skynet.newservice("watchdog")
	skynet.call(watchdog, "lua", "start", {
		port = 10101,
		maxclient = max_client,
		nodelay = true,
	})
	skynet.error("Watchdog listen on", 10101)
	skynet.exit()
end)
