local skynet = require "skynet"
local netpack = require "netpack"
local socket = require "socket"

local sproto = require "sproto"
local sprotoloader = require "sprotoloader"

local WATCHDOG
local host
local send_request

local CMD = {}
local REQUEST = {}
local client_fd


function REQUEST:login()
	skynet.sleep(100)
	return {status = 1,msg = "Login Success!",username = "zaintan",ontable = false}
end 

function REQUEST:createRoom()
	return {status = 1, fid = "100000"}
end 

function REQUEST:joinRoom()
	return {status = 1, fid = "100000"}
end

local function request(name, args, response)
	local f = assert(REQUEST[name])
	local r = f(args)
	if response then
		return response(r)
	end
end

local function send_package(pack)
	local package = string.pack(">s2", pack)
	socket.write(client_fd, package)
end


skynet.register_protocol {
	name = "client",
	id = skynet.PTYPE_CLIENT,
	unpack = function(msg, sz)
		return host:dispatch(msg,sz)
	end,
	dispatch = function (session, source, type, ...)
		if type == "REQUEST" then 
			local ok,result = pcall(request, ...)
			if ok then 
				if result then
					send_package(result) 
				end 
			else
				skynet.error(result) 
			end 
		else 
			assert(type == "RESPONSE")
			error "doesn't support request client"
		end
	end
}

function CMD.start(conf)
	host = sprotoloader.load(1):host "package"
	client_fd  = conf.client
	WATCHDOG   = conf.watchdog
	skynet.call(conf.gate, "lua", "forward", client_fd)
end

function CMD.disconnect()
	-- todo: do something before exit
	skynet.exit()
end
 

skynet.start(function()
	skynet.dispatch("lua", function(_,_, command, ...)
		print("=======lua")
		local f = CMD[command]
		skynet.ret(skynet.pack(f(...)))
	end)
end)
