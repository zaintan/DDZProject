cc.utils 				= require("framework.cc.utils.init")
cc.net 					= require("framework.cc.net.init")

local SocketManager = class("SocketManager")


SocketManager.EVENT_DATA            = "SM_SOCKET_DATA"
SocketManager.EVENT_CLOSE           = "SM_SOCKET_CLOSE"
SocketManager.EVENT_CLOSED          = "SM_SOCKET_CLOSED"
SocketManager.EVENT_CONNECTED       = "SM_SOCKET_CONNECTED"
SocketManager.EVENT_CONNECT_FAILURE = "SM_SOCKET_CONNECT_FAILURE"

function SocketManager:ctor(ip, port)
	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
	self.m_ip = ip 
	self.m_port = port

	
end

function SocketManager:openSocket(ip, port)
	self.m_ip   = ip or self.m_ip 
	self.m_port = port or self.m_port
	self:_createSocket(ip, port):_connect()
end 


function SocketManager:sendMessage(param)

end 

function SocketManager:_onStatus(__event)

	--self:dispatchEvent({name=self.EVENT_DATA, data=(__partial or __body), partial=__partial, body=__body})
end 

function SocketManager:_onData(__event)
	local data    = __event.data
	local partial = __event.partial
	local body    = __event.body

	self:dispatchEvent({name=self.EVENT_DATA, data=(__partial or __body), partial=__partial, body=__body})
end 


function SocketManager:_createSocket(ip, port)
	if not self.m_socketTcp then 
		self.m_socketTcp = cc.net.SocketTCP.new(ip, port, true)
	    self.m_socketTcp:addEventListener(cc.net.SocketTCP.EVENT_CONNECTED,       handler(self,self._onStatus))
	    self.m_socketTcp:addEventListener(cc.net.SocketTCP.EVENT_CLOSE,           handler(self,self._onStatus))
	    self.m_socketTcp:addEventListener(cc.net.SocketTCP.EVENT_CLOSED,          handler(self,self._onStatus))
	    self.m_socketTcp:addEventListener(cc.net.SocketTCP.EVENT_CONNECT_FAILURE, handler(self,self._onStatus))
	    self.m_socketTcp:addEventListener(cc.net.SocketTCP.EVENT_DATA,            handler(self,self._onData))		
	end 
	return self.m_socketTcp
end 

function SocketManager:_connect()
	self.m_socketTcp:connect(self.m_ip, self.m_port, true)
end 

return SocketManager
