local skynet = require "skynet"
local netpack = require "netpack"
local socket = require "socket"
--local sproto = require "sproto"
--local sprotoloader = require "sprotoloader"

local WATCHDOG
local CMD = {}
local client_fd
local GameTable

skynet.register_protocol {
	name = "client",
	id = skynet.PTYPE_CLIENT,
	unpack = skynet.tostring,
	dispatch = function (session, source, type, ...)
		print("client=======",session,source,type)
		socket.write(client_fd, "hello")
		--print("=======",type)
		-- if type == "REQUEST" then
		-- 	local ok, result  = pcall(request, ...)
		-- 	if ok then
		-- 		if result then
		-- 			send_package(result)
		-- 		end
		-- 	else
		-- 		skynet.error(result)
		-- 	end
		-- else
		-- 	assert(type == "RESPONSE")
		-- 	error "This example doesn't support request client"
		-- end
	end
}

function CMD.start(conf)
	local fd = conf.client
	local gate = conf.gate
	WATCHDOG = conf.watchdog

	client_fd = fd
	skynet.call(gate, "lua", "forward", fd)
end

function CMD.disconnect()
	-- todo: do something before exit
	skynet.exit()
end

--test
function CMD.testLa()
	skynet.sleep(10)
end 

skynet.start(function()
	skynet.dispatch("lua", function(_,_, command, ...)
		print("=======lua")
		local f = CMD[command]
		skynet.ret(skynet.pack(f(...)))
	end)
end)
