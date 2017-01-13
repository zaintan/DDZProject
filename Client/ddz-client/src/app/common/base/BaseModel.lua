--[[
	@desc:数据层基础类
]]

BaseModel = class("BaseModel", cc.mvc.ModelBase)

BaseModel.schema = clone(cc.mvc.ModelBase.schema)

function BaseModel:ctor(  )
	BaseModel.super.ctor(self)
end