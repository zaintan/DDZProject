
require("config")
require("cocos.init")
require("framework.init")
require("app.common.init")

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    cc.FileUtils:getInstance():addSearchPath("res/")
    cc.Director:getInstance():setContentScaleFactor(640 / CONFIG_SCREEN_HEIGHT)
    self:enterScene("MainScene")
end

return MyApp
