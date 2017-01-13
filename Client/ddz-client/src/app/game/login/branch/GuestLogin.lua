--[[
	@desc:游客登录
]]
local BaseLogin = import(".BaseLogin")
local GuestLogin = class("GuestLogin", BaseLogin)

function GuestLogin:ctor(  )
	self.mType = GameConstant.LoginType.GUEST 
end

function GuestLogin:login(  )
	local smid = "test123"
	local data = {
		smid = smid,
		type = self.mType 
	}
	LoginController.getInstance():doLogin(data)
end

function GuestLogin:getType(  )
	return self.mType
end

return GuestLogin