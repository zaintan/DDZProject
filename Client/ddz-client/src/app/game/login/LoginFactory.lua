--[[
	@desc:登录工厂类
]]

local LoginFactory = class("LoginFactory")

function LoginFactory:ctor(  )
	LoginFactory.Instance = self 
	self.mLoginMap = {}         --登录索引类
end

function LoginFactory.getInstance(  )
	if LoginFactory.Instance == nil then 
		LoginFactory.Instance = LoginFactory.new()
	end
	return LoginFactory.Instance 
end

--[[
	@desc:创建登录类，已经存在则不创建,内部方法，外部不可调用
	@param:
		loginType:登录类型
]]
function LoginFactory:createLogin( loginType )
	PrintLog("LoginFactory:createLogin, loginType:%s", tostring(loginType))
	if loginType == GameConstant.LoginType.GUEST then 		--游客
		local GuestLogin = require("app.game.login.branch.GuestLogin")
		self.mLoginMap[loginType] = GuestLogin.new()
	elseif loginType == GameConstant.LoginType.WECHAT then  --微信
		local WechatLogin = require("app.game.login.branch.WechatLogin")
		self.mLoginMap[loginType] = WechatLogin.new()
	end
end

--[[
	@desc:获得登录类实例
	@param:
		loginType:登录类型
	@return: 登录实例
]]
function LoginFactory:getLogin( loginType )
	if self.mLoginMap[loginType] == nil then 
		self:createLogin(loginType)
	end
	return self.mLoginMap[loginType]
end

return LoginFactory