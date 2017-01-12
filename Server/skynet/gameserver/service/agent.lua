local skynet = require "skynet"
local netpack = require "netpack"
local socket = require "socket"

local sproto = require "sproto"
local sprotoloader = require "sprotoloader"
local queue = require "skynet.queue"

local cs = queue()
local WATCHDOG
local host
local send_request

local CMD = {}
local REQUEST = {}
local client_fd
--local uid
--local 

--login..根据client传过来simid(唯一标识) 找到账号信息--uid,name,money,ontable状态
function REQUEST:login()
	local us   = skynet.localname(".userservice")
	local info = skynet.call(us,"lua","login",{smid = self.smid, type = self.type})
	return info
end 

function REQUEST:createRoom()
	print("createRoom sleep before")
	--skynet.sleep(200)
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


local function recv_package(type, ... )
	print("recv_package:",type)
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

--##bug: 测试 发现 非按序处理
skynet.register_protocol {
	name = "client",
	id = skynet.PTYPE_CLIENT,
	unpack = function(msg, sz)
		return host:dispatch(msg,sz)
	end,
	dispatch = function (session, source, type, result,response,headerud)
		print("recieve client :", session, type, result,response,headerud)
		cs(recv_package,type,result,response,headerud)
		--cs(function()
		--	recv_package(type,result,response,headerud)
		--end)
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
