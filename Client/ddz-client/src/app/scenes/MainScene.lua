cc.utils 				= require("framework.cc.utils.init")
cc.net 					= require("framework.cc.net.init")

local SocketTCP = cc.net.SocketTCP

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

function MainScene:send2Socket(__msg)
     -- sproto 简单测试
    local sproto = require "lualib.sproto.sproto"
    local protocol = require "app.protocol.messageDef"
    local sp = sproto.parse(protocol)

    local data = {}
    data.content = "hello,world!"
    data.bools   = {true,false,false,true}
    data.number  = 10 
    data.user    = { age = 1, name = "ddz"}

    local packet = sp:encode("HelloMsg", data)
    print(string.format("packet => size: %s", #packet))

    
    local dd = sp:decode("HelloMsg", packet)
    dump(dd,"<Send MSG to Server:>")

    local ba = cc.utils.ByteArray.new(cc.utils.ByteArray.ENDIAN_BIG)
    ba:writeShort(#packet)


    self.m_socketTcp:send(ba:getBytes()..packet)
end

function MainScene:onData(__event)
	printInfo("socket receive raw data:",__event.data)--, cc.utils.ByteArray.toString(__event.data, 16))
	print(__event.data:byte(1,string.len(__event.data)))

         -- sproto 简单测试
    local sproto = require "lualib.sproto.sproto"
    local protocol = require "app.protocol.messageDef"
    local sp = sproto.parse(protocol)

    print(string.format("packet => size: %s", #__event.data - 2))
    local dd = sp:decode("Answer", string.sub(__event.data,3))
    dump(dd,"<recv MSG from Server:>")
end

return MainScene
