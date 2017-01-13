--[[
	local ss = require("utils/socketSend")
	ss.sendMsg(client_fd,"joinRoom",{fid = "100001",uid="1001"})
]]
local socketSend = {}

local socket = require "socket"
local sproto = require "sproto"
local sprotoloader = require "sprotoloader"

local host         = sprotoloader.load(1):host "package"
local send_request = host:attach(sprotoloader.load(1))

function socketSend.sendMsg(fd, protoname, param)
	print("socketSend.sendMsg",fd, protoname)
    local sendPacket = send_request(protoname,param)
    local package = string.pack(">s2", sendPacket)
    print(package)
    socket.write(fd, package)
end 

return socketSend