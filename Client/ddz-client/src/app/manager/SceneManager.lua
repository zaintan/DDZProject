--[[
	@desc:场景管理器，用于场景切换，场景创建销毁等
]]
SceneManager = class("SceneManager")

function SceneManager:ctor(  )
	if SceneManager.Instance ~= nil then 
		printError("SceneManager rereate error!")
		return
	end
	SceneManager.Instance = self
end

function SceneManager:getInstance(  )
	if SceneManager.Instance == nil then 
		return SceneManager.new()
	end
	return SceneManager.Instance
end