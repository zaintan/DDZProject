--[[
	desc:全局函数,不在functions下添加，防止污染框架
]]

--[[
	@desc:在调试状态下打印相关日志
	@param:tag：日志标签，fmt：调试信息格式，...更多参数
]]
function DebugLog( tag, fmt, ... )
	if DEBUG > 0 then --打印日志
		if fmt ~= nil then 
			printLog(tag, fmt, ...)
		else
			printInfo(tag, ...)
		end
	end
end

--[[
	@desc:在调试状态下打印相关日志
	@param:fmt：调试信息格式，...更多参数
]]
function PrintLog( fmt, ... )
	if DEBUG > 0 then --打印日志
		printInfo(fmt, ...)
	end
end