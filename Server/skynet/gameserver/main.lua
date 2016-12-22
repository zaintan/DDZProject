local skynet    = require "skynet.manager"
--local TAG = 'main'

local max_client = 64

skynet.start(function()
	skynet.error("Server start")
	--skynet.uniqueservice("gameservice")
	skynet.uniqueservice("protoloader")
	--if not skynet.getenv "daemon" then
	--	local console = skynet.newservice("console")
	--end
	--skynet.newservice("debug_console",8000)
	--skynet.newservice("simpledb")
	local watchdog = skynet.newservice("watchdog")
	skynet.call(watchdog, "lua", "start", {
		port = 10101,
		maxclient = max_client,
		nodelay = true,
	})
	skynet.error("Watchdog listen on", 10101)
	skynet.exit()
end)
