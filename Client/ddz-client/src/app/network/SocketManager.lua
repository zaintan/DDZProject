cc.utils 				= require("framework.cc.utils.init")
cc.net 					= require("framework.cc.net.init")

local proto  			= require "app.protocol.messageDef"
local sproto 			= require "lualib.sproto.sproto"
local host 				= sproto.new(proto.c2s):host "package"

local SocketManager 	= class("SocketManager")
local request 			= host:attach(sproto.new(proto.c2s))

SocketManager.EVENT_DATA            = "SM_SOCKET_DATA"
SocketManager.EVENT_CLOSE           = "SM_SOCKET_CLOSE"
SocketManager.EVENT_CLOSED          = "SM_SOCKET_CLOSED"
SocketManager.EVENT_CONNECTED       = "SM_SOCKET_CONNECTED"
SocketManager.EVENT_CONNECT_FAILURE = "SM_SOCKET_CONNECT_FAILURE"


function SocketManager:ctor(ip, port)
	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
	self.m_ip        = ip 
	self.m_port    	 = port
	self.m_session 	 = 0
	self.m_connected = false

	self.m_sessionMap = {}
end

function SocketManager:openSocket(ip, port)
	self.m_ip   = ip or self.m_ip 
	self.m_port = port or self.m_port
	self:_createSocket(ip, port)
	self:_connect()
end 


function SocketManager:sendMessage(protoName,params)
	if not self.m_connected then 
		return 
	end 

	local session    = self:_accumulationSession()
	local sendPacket = request(protoName,params,session)
	self.m_sessionMap[session] = protoName--记录session 与 protoHead的映射关系
	local head       = cc.utils.ByteArray.new(cc.utils.ByteArray.ENDIAN_BIG)
	head:writeShort(#sendPacket)
	self.m_socketTcp:send(head:getBytes()..sendPacket)
end 


function SocketManager:_onStatusConnectFailed(__event)
	printInfo("_onStatusConnectFailed")
	self.m_connected = false 
	self:dispatchEvent({name=self.EVENT_CONNECT_FAILURE})
end 

function SocketManager:_onStatusClosed(__event)
	printInfo("_onStatusClosed")
	self.m_connected = false 
	self:dispatchEvent({name=self.EVENT_CLOSED})
end 

function SocketManager:_onStatusClose(__event)
	printInfo("_onStatusClose")
	self.m_connected = false 
	self:dispatchEvent({name=self.EVENT_CLOSE})
end 

function SocketManager:_onStatusConnected(__event)
	printInfo("_onStatusConnected")
	self.m_connected = true 
	self:dispatchEvent({name=self.EVENT_CONNECTED})
end 


--recv message 注意处理粘包情况
function SocketManager:_onData(__event)
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
        if self.m_sessionMap[session] then 
        	head = self.m_sessionMap[session]
        	self.m_sessionMap[session] = nil
        end 
        self:dispatchEvent({name=self.EVENT_DATA, head = head,data = msg})--
    end	
end 


function SocketManager:_createSocket(ip, port)
	if not self.m_socketTcp then 
		self.m_socketTcp = cc.net.SocketTCP.new(ip, port)
	    self.m_socketTcp:addEventListener(cc.net.SocketTCP.EVENT_CONNECTED,       handler(self,self._onStatusConnected))
	    self.m_socketTcp:addEventListener(cc.net.SocketTCP.EVENT_CLOSE,           handler(self,self._onStatusClose))
	    self.m_socketTcp:addEventListener(cc.net.SocketTCP.EVENT_CLOSED,          handler(self,self._onStatusClosed))
	    self.m_socketTcp:addEventListener(cc.net.SocketTCP.EVENT_CONNECT_FAILURE, handler(self,self._onStatusConnectFailed))
	    self.m_socketTcp:addEventListener(cc.net.SocketTCP.EVENT_DATA,            handler(self,self._onData))		
	end 
	return self.m_socketTcp
end 

function SocketManager:_connect() 
	printInfo("start connecting ip=[%s], port=[%d]",self.m_ip, self.m_port)
	self.m_socketTcp:connect(self.m_ip, self.m_port)
end 

function SocketManager:_accumulationSession()
	self.m_session = self.m_session + 1
	if self.m_session >= 0xFFFFFFFF then 
		self.m_session = 0 
	end 
	return self.m_session
end 

return SocketManager
