--[[
	#desc:本地数据储存类
]]
DiskDataManager = class("DiskDataManager")
local GameState = require(cc.PACKAGE_NAME .. ".cc.utils.GameState")

function DiskDataManager:ctor(  )
	if DiskDataManager.Instance ~= nil then 
		printError("DiskDataManager rereate error!")
		return
	end
	DiskDataManager.Instance = self 
	self.fileName = "UserData.db" 		--文件名称		
	self.secretKey = "coopy" 			--密钥
	self.encryptStr = "abcd"			--加密串

	self.mData = {}						--内部维护的数据表

	self:init()
end

function DiskDataManager:init(  )
	local initFunc = function ( param )
		local returnValue = nil 
		if param.errorCode then 
			printError("GameState.init error:%s", tostring(param.errorCode))
		else
			if param.name == "save" then       --数据保存
				local str = json.encode(param.values)
				str = crypto.encryptXXTEA(str, self.encryptStr)
				returnValue = {data = str}
			elseif param.name == "load" then   --数据加载
				local str = crypto.decryptXXTEA(param.values.data, self.encryptStr)	
				returnValue = json.decode(str)
			end
		end
		return returnValue
	end
	GameState.init(initFunc, self.fileName, self.secretKey)
	PrintLog("本地数据是否文件存在:%s， 文件路径为:%s", tostring(io.exists(GameState.getGameStatePath())), tostring(GameState.getGameStatePath()))
	if io.exists(GameState.getGameStatePath()) then 
		self.mData = GameState.load()
		dump(self.mData)
	end
end

function DiskDataManager.getInstance(  )
	if DiskDataManager.Instance == nil then 
		return DiskDataManager.new()
	end
	return DiskDataManager.Instance
end

function DiskDataManager:checkType( checkType, value )
	if type(value) ~= checkType then 
		printError("value is not %s, value is:%s", tostring(checkType), tostring(value))
		return false 
	else
		return true 
	end
end

--[[
	@desc:保存数据
	@param
		key:数据key
		value:数据
		isSaveImm:是否立即存储到磁盘
]]
function DiskDataManager:putValue( key, value, isSaveImm )
	self.mData[key] = value 
	if isSaveImm then 
		self:saveData()
	end
end

--[[
	@desc:保存number类型数据
	@param:
		key:key值
		value:数据
		isSaveImm:是否立即存储
]]
function DiskDataManager:putNumber( key, value, isSaveImm )
	if self:checkType("number", value) then 
		self.mData[key] = value 
		if isSaveImm then 
			self:saveData()
		end
	end
end

--[[
	@desc:保存boolean类型数据
	@param:
		key:key值
		value:数据
		isSaveImm:是否立即存储
]]
function DiskDataManager:putBoolean( key, value, isSaveImm )
	if self:checkType("boolean", value) then 
		self.mData[key] = value 
		if isSaveImm then 
			self:saveData()
		end
	end
end

--[[
	@desc:保存string类型数据
	@param:
		key:key值
		value:数据
		isSaveImm:是否立即存储
]]
function DiskDataManager:putString( key, value, isSaveImm )
	if self:checkType("string", value) then 
		self.mData[key] = value 
		if isSaveImm then 
			self:saveData()
		end
	end
end

--[[
	@desc:保存table类型数据
	@param:
		key:key值
		value:数据
		isSaveImm:是否立即存储
]]
function DiskDataManager:putTable( key, value, isSaveImm )
	if self:checkType("table", value) then 
		self.mData[key] = value 
		if isSaveImm then 
			self:saveData()
		end
	end
end

--[[
	@desc:获取数据
	@param:
		key:数据key
		@defValue:默认值
	@return value 
]]
function DiskDataManager:getValue( key, defValue )
	local value = self.mData[key]
	if value == nil and defValue ~= nil then 
		value = defValue 
	end
	return value 
end

--[[
	@desc:获取number类型数据
	@param:
		key:数据key
		defValue:取不到的默认值
	@return value
]]
function DiskDataManager:getNumber( key, defValue )
	local value = self.mData[key]
	if value == nil and defValue ~= nil then 
		value = defValue
	end
	return value 
end

--[[
	@desc:获取boolean类型数据
	@param:
		key:数据key
		defValue:取不到的默认值
	@return value
]]
function DiskDataManager:getBoolean( key, defValue )
	local value = self.mData[key]
	if value == nil and defValue ~= nil then 
		value = defValue
	end
	return value 
end

--[[
	@desc:获取string类型数据
	@param:
		key:数据key
		defValue:取不到的默认值
	@return value
]]
function DiskDataManager:getString( key, defValue )
	local value = self.mData[key]
	if value == nil and defValue ~= nil then 
		value = defValue
	end
	return value 
end

--[[
	@desc:获取table类型数据
	@param:
		key:数据key
		defValue:取不到的默认值
	@return value
]]
function DiskDataManager:getTable( key, defValue )
	local value = self.mData[key]
	if value == nil and defValue ~= nil then 
		value = defValue
	end
	return value 
end

function DiskDataManager:saveData(  )
	GameState.save(self.mData)
end
