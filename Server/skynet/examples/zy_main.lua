local skynet = require "skynet"
local sprotoloader = require "sprotoloader"
local max_client = 64

skynet.start(function()
	skynet.uniqueservice("protoloader")	
	--print('[LOG]',os.date('%m-%d-%Y %X', skynet.starttime()),'Server start')
	skynet.newservice('zy')

	local watchdog = skynet.newservice('watchdog')
	skynet.call(watchdog, 'lua', 'start',{
		port = 10101,
		maxclient = max_client,
	})
	
	skynet.exit()
end)
