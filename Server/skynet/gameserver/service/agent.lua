local skynet = require "skynet"
local netpack = require "netpack"
local socket = require "socket"
local sproto = require "sproto"

local sp = sproto.parse(require("protocol/proto"))

local WATCHDOG
local CMD = {}
local client_fd
local GameTable

skynet.register_protocol {
	name = "client",
	id = skynet.PTYPE_CLIENT,
	unpack = skynet.tostring,
	dispatch = function (session, source, msg, ...)
		print("recv client msg:",session,source)
		print("type=[%s]",type(msg))
		local param = sp:decode("HelloMsg",msg)
		Log.d("agent","=============")
		Log.dump("agent",param)
		Log.d("agent","=============")

		local res = {}
		res.name = "gameServer"
		res.content = "hello over!"
		local response = sp:encode("Answer", res)

		print(string.format("response packet => size: %s", string.len(response)))
		socket.write(client_fd, string.pack("<I2", string.len(response)) .. response)
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
