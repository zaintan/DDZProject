--[[
	@desc:场景管理器，用于场景切换，场景创建销毁等
]]
SceneManager = class("SceneManager")

SceneManager.ON_KEYPAD_EVENT = "SM_ON_KEYPAD_EVENT"     --手机按返回键事件

SceneManager.MAIN_SCENE = "MainScene"					--主场景
SceneManager.ROOM_SCENE = "RoomScene"					--房间场景

function SceneManager:ctor(  )
	if SceneManager.Instance ~= nil then 
		printError("SceneManager rereate error!")
		return
	end
	SceneManager.Instance = self
	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
	self.mCurScene = nil 	--当前场景
	self:addEvent()
end

function SceneManager.getInstance(  )
	if SceneManager.Instance == nil then 
		return SceneManager.new()
	end
	return SceneManager.Instance
end

function SceneManager:addEvent(  )
	self:addEventListener(SceneManager.ON_KEYPAD_EVENT, handler(self, self.onKeypadEvent))
end

--手机键监听
function SceneManager:onKeypadEvent( eventData )
	local event = eventData.data
	PrintLog("SceneManager:onKeypadEvent, key:%s, keyType:%s", event.key, type(event.key))
	if event.key == "back" or event.key == "125" then --返回键
		if not WindowManager.getInstance():onKeyBack() then --没有窗口关闭了
			device.showAlert("温馨提示", "您确定要退出游戏吗？", {"确定", "取消"}, function (event)  
	            if event.buttonIndex == 1 then    
	            	DiskDataManager.getInstance():saveData()   --保存数据
	                cc.Director:getInstance():endToLua()  
	            else    
	                device.cancelAlert()  --取消对话框   
	            end    
	        end)  
		end
	end
end

--[[
	@desc:进入某个场景
	@param:
			name:场景名称，见SceneManager的定义
			transitionType:动画类型
			time:动画时间
]]
function SceneManager:enterScene( name, data )
	local scenePackageName = "app.scenes." .. name
    local sceneClass = require(scenePackageName)
    local scene = sceneClass.new(data)
	local transition = display.wrapSceneWithTransition(scene, "fade", 0.5)
	display.replaceScene(transition)
	self.mCurScene = scene
	PrintLog("当前场景是：%s", name)
	--设置按钮监听
	scene:setKeypadEnabled(true)
    scene:addNodeEventListener(cc.KEYPAD_EVENT, handler(self, self.onKeyPadEvent))
end

--点击返回键
function SceneManager:onKeyPadEvent( event )
    PrintLog("监听按键, 按键id是：%s，按键名称：%s", tostring(event.key), tostring(event.name))
    self:dispatchEvent({name = SceneManager.ON_KEYPAD_EVENT, data = event})
end

--[[
	@desc:获取当前场景
	@return 当前场景对象
]]
function SceneManager:getCurScene(  )
	return self.mCurScene
end

--[[
	@desc:销毁场景
]]
function SceneManager:deleteCurScence(  )
	if self.mCurScene ~= nil then 
		self.mCurScene:removeSelf()
	end
end
