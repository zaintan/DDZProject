--[[
	@desc:场景管理器，用于场景切换，场景创建销毁等
]]
LayerManager = class("LayerManager")

function LayerManager:ctor(  )
	if LayerManager.Instance ~= nil then 
		printError("LayerManager rereate error!")
		return
	end
	LayerManager.Instance = self
end

function LayerManager:getInstance(  )
	if LayerManager.Instance == nil then 
		return LayerManager.new()
	end
	return LayerManager.Instance
end