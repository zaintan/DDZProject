
local RoomScene = class(SceneManager.ROOM_SCENE, function (  )
	return display.newScene(SceneManager.ROOM_SCENE)
end)

function RoomScene:ctor(  )
	PrintLog("RoomScene:ctor")
	self:initView()
	self:addEvent()
end

function RoomScene:initView(  )
	local roomScene = cc.uiloader:load(VIEW_PATH .. "RoomScene.json")
	self:addChild(roomScene)

	local compomentArr = {"btnBack"}
	for k, v in ipairs(compomentArr) do
		self[v] = cc.uiloader:seekNodeByName(roomScene, "btnBack")
	end
end

function RoomScene:addEvent(  )
    --按钮事件
    self.btnBack:onButtonClicked(function (  )
    	SceneManager.getInstance():enterScene(SceneManager.MAIN_SCENE)
    end)
end

--场景进入
function RoomScene:onEnter(  )
	PrintLog("RoomScene:onEnter")
end

--场景退出
function RoomScene:onExit(  )
	PrintLog("RoomScene:onExit")
end

return RoomScene