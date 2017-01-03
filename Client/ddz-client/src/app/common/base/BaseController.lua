--[[
	@desc:控制层的基础类
]]

BaseController = class("BaseController", AppBase)

function BaseController:ctor(  )
	AppBase.super.ctor(self)
end