
require("config")
require("cocos.init")
require("framework.init")
require("app.common.init")

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
    self:init()
end

function MyApp:run()
    cc.FileUtils:getInstance():addSearchPath("res/")
    cc.Director:getInstance():setContentScaleFactor(640 / CONFIG_SCREEN_HEIGHT)
    SceneManager.getInstance():enterScene(SceneManager.LOAD_SCENE)
end

function MyApp:init(  )
	LoginController = LoginController or require("app.game.login.LoginController")

	GameSocketMgr = GameSocketMgr or (require("app.network.SocketManager")).new(GameConstant.ServerConfig.IP, GameConstant.ServerConfig.PORT)
end

return MyApp
