local LoginModel = import(".LoginModel")
local LoginFactory = import(".LoginFactory")

local LoginController = class("LoginController", BaseController)

function LoginController:ctor(  )
	if LoginController.Instance ~= nil then 
		printError("LoginController rereate error!")
		return
	end
	LoginController.Instance = self

	self.mLoginModel = LoginModel.new()
	self:addEvent()
end

function LoginController.getInstance(  )
	if LoginController.Instance == nil then
		LoginController.Instance = LoginController.new()
	end
	return LoginController.Instance 
end

function LoginController:getModel(  )
	return self.mLoginModel
end

function LoginController:addEvent(  )
	GameSocketMgr:addEventListener(GameSocketMgr.EVENT_DATA,            handler(self,self.onData))
end

function LoginController:onData( __event )
	local head, data = __event.head, __event.data 
	PrintLog("LoginController:onData, head:%s", tostring(head))
	dump(data)
	self:loginServerResp(data) --test
	-- if data.head == "login" then --登录返回

	-- end
end

--server登录返回
function LoginController:loginServerResp( data )
	if data.status == 1 then   		--login success
		self.mLoginModel:setCurLoginType(data.loginType)
		if data.ontable then        --in table
			--do something
		else
	   		--enter hall
	   		SceneManager.getInstance():enterScene(SceneManager.MAIN_SCENE)
	   	end   
	else
		PrintLog("LoginServerResp login fail, msg:%s", tostring(data.msg))
	end
end

--[[
	@desc:请求登录
	@param:
		loginType:登录类型
]]
function LoginController:tryLogin( loginType )
	PrintLog("LoginController:tryLogin, type:%s", tostring(loginType))
	loginType = loginType or GameConstant.LoginType.GUEST
	local factory = LoginFactory.new()
	LoginFactory.getInstance():getLogin(loginType):login()
end

--[[
	@desc:登录服务端
]]
function LoginController:doLogin( data )
	PrintLog("进行server登录")
	GameSocketMgr:sendMessage("login", data)
end

return LoginController