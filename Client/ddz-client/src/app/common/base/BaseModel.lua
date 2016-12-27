--[[
	@desc:数据层基础类
]]

BaseModel = class("BaseModel", ModelBase)

function BaseModel:ctor(  )
	ModelBase.super.ctor(self)
end