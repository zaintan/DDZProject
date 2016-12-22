cc.utils 				= require("framework.cc.utils.init")
cc.net 					= require("framework.cc.net.init")

local SocketTCP = cc.net.SocketTCP

g_print = printInfo


local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
	--cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
    local label = cc.ui.UILabel.new({
            UILabelType = 2, text = "127.0.0.1:10101", size = 64})
        :align(display.LEFT_TOP, 0, display.height)
        :addTo(self)


    --self:addEventListener(cc.net.SocketTCP.EVENT_DATA, listener, tag)
    self.m_socketTcp = cc.net.SocketTCP.new('127.0.0.1',10101,3)
	self.m_socketTcp:addEventListener(cc.net.SocketTCP.EVENT_CONNECTED,       handler(self,self.onStatus))
	self.m_socketTcp:addEventListener(cc.net.SocketTCP.EVENT_CLOSE,           handler(self,self.onStatus))
	self.m_socketTcp:addEventListener(cc.net.SocketTCP.EVENT_CLOSED,          handler(self,self.onStatus))
	self.m_socketTcp:addEventListener(cc.net.SocketTCP.EVENT_CONNECT_FAILURE, handler(self,self.onStatus))
	self.m_socketTcp:addEventListener(cc.net.SocketTCP.EVENT_DATA,            handler(self,self.onData))

    self.m_socketTcp:connect()


end

function MainScene:onEnter()
end

function MainScene:onExit()
end



function MainScene:onStatus(__event)
	printInfo("socket status: %s", __event.name)

    if __event.name == SocketTCP.EVENT_CONNECTED then 
        local scheduler = require("framework.scheduler")
        local handler = nil 
        handler = scheduler.scheduleGlobal(function()
            scheduler.unscheduleGlobal(handler)
            self:send2Socket()
        end,3.0)
        --scheduler(SEL_SCHEDULE selector, float interval, unsigned int repeat, float delay)
        --
    end 
end

-- sproto 简单测试
local session = 0
local proto  = require "app.protocol.messageDef"
local sproto = require "lualib.sproto.sproto"
local host = sproto.new(proto.c2s):host "package"
local request = host:attach(sproto.new(proto.c2s))

local function send_request(socketTcp,name, args)
    session = session + 1
    print("send_request:", name, session)
    local packet = request(name, args, session)

    local ba = cc.utils.ByteArray.new(cc.utils.ByteArray.ENDIAN_BIG)
    ba:writeShort(#packet)   
    socketTcp:send(ba:getBytes() ..packet)
end 

function MainScene:send2Socket(__msg)
    send_request(self.m_socketTcp,"login",{smid = "zainmac1990",type = 1})
    send_request(self.m_socketTcp,"createRoom",{level = 1,playtype = 1})
end



function MainScene:onData(__event)
	printInfo("socket receive raw data:",__event.data)--, cc.utils.ByteArray.toString(__event.data, 16))
	
    local function unpack_package(text)
        local size = #text
        if size < 2 then
            return nil, text
        end
        local s = text:byte(1) * 256 + text:byte(2)
        if size < s+2 then
            return nil, text
        end

        return text:sub(3,2+s), text:sub(3+s)
    end

    local last = __event.data
    while true do
        local v
        v, last = unpack_package(last)
        if not v then
            break
        end
        local head,session,msg = host:dispatch(v)
        self:recvPacketFromServer(head,msg)
    end

end

function MainScene:recvPacketFromServer(head,msgContent)
    dump(msgContent,"<recv MSG from Server:>")
end 

return MainScene
