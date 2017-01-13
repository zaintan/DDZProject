cc.utils 				= require("framework.cc.utils.init")
cc.net 					= require("framework.cc.net.init")

local SocketManager             = require "app.network.SocketManager"

local MainScene = class(SceneManager.MAIN_SCENE, function()
    return display.newScene(SceneManager.MAIN_SCENE)
end)

function MainScene:ctor()
	--cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
    local mainScene = cc.uiloader:load(VIEW_PATH .. "MainScene.json")
    local wnd1 = cc.uiloader:seekNodeByNameFast(mainScene, "wnd1")
    wnd1:onButtonClicked(function (  )
        WindowManager.getInstance():showWindow(self, WindowId.LoginPopu, {}, WindowStyle.Popu)
    end)
    self:addChild(mainScene)
    local btnRoomScene = cc.uiloader:seekNodeByNameFast(mainScene, "btnRoomScene")
    btnRoomScene:onButtonClicked(function (  )
        SceneManager.getInstance():enterScene(SceneManager.ROOM_SCENE)
    end)

    local label = cc.ui.UILabel.new({
            UILabelType = 2, text = "127.0.0.1:10101", size = 64})
        :align(display.LEFT_TOP, 0, display.height)
        :addTo(self)

    self.m_socketTcp = SocketManager.new('127.0.0.1',10101)
    self.m_socketTcp:addEventListener(SocketManager.EVENT_CONNECTED,       handler(self,self.onStatus))
	self.m_socketTcp:addEventListener(SocketManager.EVENT_CLOSE,           handler(self,self.onStatus))
	self.m_socketTcp:addEventListener(SocketManager.EVENT_CLOSED,          handler(self,self.onStatus))
	self.m_socketTcp:addEventListener(SocketManager.EVENT_CONNECT_FAILURE, handler(self,self.onStatus))
	self.m_socketTcp:addEventListener(SocketManager.EVENT_DATA,            handler(self,self.onData))
    self.m_socketTcp:openSocket()
end

function MainScene:onEnter()
end

function MainScene:onExit()
end



function MainScene:onStatus(__event)
	printInfo("socket status: %s", __event.name)

    if __event.name == SocketManager.EVENT_CONNECTED then 
        local scheduler = require("framework.scheduler")
        local handler = nil 
        handler = scheduler.scheduleGlobal(function()
            scheduler.unscheduleGlobal(handler)
            self.m_socketTcp:sendMessage("login",{smid = "zainmac1992",type = 1})
            --self.m_socketTcp:sendMessage("createRoom",{level = 1,playtype = 1})
        end,3.0)
        --scheduler(SEL_SCHEDULE selector, float interval, unsigned int repeat, float delay)
        --
    end 
end



function MainScene:onData(__event)
	--printInfo("socket receive raw data:",__event.data)--, cc.utils.ByteArray.toString(__event.data, 16))
    self:recvPacketFromServer(__event.head,__event.protoname, __event.data)
end

function MainScene:recvPacketFromServer(head,protoname,msgContent)
    print(head,protoname)
    dump(msgContent,"<recv MSG from Server:>")
end 

return MainScene
