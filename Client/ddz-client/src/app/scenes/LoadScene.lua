--[[
	@desc:加载场景，也是进行游戏更新和登录的场景
]]

local LoadScene = class(SceneManager.LOAD_SCENE, function (  )
	return display.newScene(SceneManager.LOAD_SCENE)
end)

function LoadScene:ctor(  )
	PrintLog("LoadScene:ctor")

	self:initView()
	self:addEvent()
	self:connectSocket()

end

function LoadScene:initView(  )
	local roomScene = cc.uiloader:load(VIEW_PATH .. "LoadScene.json")
	self:addChild(roomScene)

	local compomentArr = {"btnGuest", "btnWechat", "loginPanel"}
	for k, v in ipairs(compomentArr) do
		self[v] = cc.uiloader:seekNodeByName(roomScene, v)
	end

	local label = cc.ui.UILabel.new({
            UILabelType = 2, text = string.format("%s:%d",GameConstant.ServerConfig.IP, GameConstant.ServerConfig.PORT), size = 32})
        :align(display.LEFT_TOP, 0, display.height)
        :addTo(self)
end

function LoadScene:addEvent(  )
    --按钮事件
    self.btnGuest:onButtonClicked(function (  )
    	LoginController.getInstance():tryLogin(GameConstant.LoginType.GUEST)
    end)

    self.btnWechat:onButtonClicked(function (  )
    	PrintLog("Wechat Login ... ")
    end)

    --socket监听
    GameSocketMgr:addEventListener(GameSocketMgr.EVENT_CONNECTED,       handler(self,self.onStatus))
	GameSocketMgr:addEventListener(GameSocketMgr.EVENT_CONNECT_FAILURE, handler(self,self.onStatus))
end

function LoadScene:connectSocket(  )
    GameSocketMgr:openSocket()
end

function LoadScene:onStatus(__event)
	printInfo("socket status: %s", __event.name)

    if __event.name == GameSocketMgr.EVENT_CONNECTED then               --connect success
        self.loginPanel:setVisible(true)
    elseif __event.name == GameSocketMgr.EVENT_CONNECT_FAILURE then     --connect fail
    	device.showAlert("温馨提示", "连接错误，请检查网络。", {"确定"}, function (event)  
            if event.buttonIndex == 1 then    
                cc.Director:getInstance():endToLua()  
            end    
        end) 
    end
end

--场景进入
function LoadScene:onEnter(  )
	PrintLog("LoadScene:onEnter")
end

--场景退出
function LoadScene:onExit(  )
	PrintLog("LoadScene:onExit")
end

return LoadScene