local socketSend = {}

local skynet = require "skynet"
local socket = require "socket"
local sproto = require "sproto"
local sprotoloader = require "sprotoloader"

local host         = sprotoloader.load(1):host "package"
local send_request = host:attach(sprotoloader.load(1))

function socketSend.sendMsg(fd, protoname, param)
	print("socketSend.sendMsg",fd, protoname)
    local sendPacket = send_request(protoname,params,skynet.genid())
    local package = string.pack(">s2", sendPacket)
    print(package)
    socket.write(fd, package)
end 

return socketSend