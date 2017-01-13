--[[
	@desc:微信登录类
]]

local BaseLogin = import(".BaseLogin")
local WechatLogin = class("WechatLogin", BaseLogin)

function WechatLogin:ctor(  )
	self.mType = GameConstant.LoginType.WECHAT 
end

function WechatLogin:login(  )
	
end

function WechatLogin:getType(  )
	return self.mType
end

return WechatLogin