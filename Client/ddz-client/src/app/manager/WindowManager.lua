--[[
	@desc:窗口管理类
]]

WindowManager = class("WindowManager")

function WindowManager:ctor(  )
	if WindowManager.Instance ~= nil then 
		printError("WindowManager rereate error!")
		return
	end
	WindowManager.Instance = self
end

function WindowManager:getInstance(  )
	if WindowManager.Instance == nil then 
		return WindowManager.new()
	end
	return WindowManager.Instance
end