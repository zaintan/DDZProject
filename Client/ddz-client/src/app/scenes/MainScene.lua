cc.utils 				= require("framework.cc.utils.init")
cc.net 					= require("framework.cc.net.init")
local MainScene = class(SceneManager.MAIN_SCENE, function()
    return display.newScene(SceneManager.MAIN_SCENE)
end)

function MainScene:ctor()
	--cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
    local mainScene = cc.uiloader:load(VIEW_PATH .. "MainScene.json")
    local wnd1 = cc.uiloader:seekNodeByNameFast(mainScene, "wnd1")
    wnd1:onButtonClicked(function (  )
        WindowManager.getInstance():showWindow(self, WindowId.LoginPopu, {model = LoginController.getInstance():getModel()}, WindowStyle.Popu)
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
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
