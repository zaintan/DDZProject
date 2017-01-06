--[[
	@desc:场景管理器，用于场景切换，场景创建销毁等
]]
SceneManager = class("SceneManager")

SceneManager.ON_KEYPAD_EVENT = "SM_ON_KEYPAD_EVENT"     --手机按返回键事件

function SceneManager:ctor(  )
	if SceneManager.Instance ~= nil then 
		printError("SceneManager rereate error!")
		return
	end
	SceneManager.Instance = self
	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()

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
	                cc.Director:getInstance():endToLua()  
	            else    
	                device.cancelAlert()  --取消对话框   
	            end    
	        end)  
		end

	end
end