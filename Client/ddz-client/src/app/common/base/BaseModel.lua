--[[
	@desc:数据层基础类
]]

BaseModel = class("BaseModel", cc.mvc.ModelBase)

function BaseModel:ctor(  )
	BaseModel.super.ctor(self)
end