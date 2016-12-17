require("skynet.manager")
local skynet = require "skynet"

local CMD = {}

--[[
skynet消息组成:
1.session: 请求者的内部标识---标识唯一请求
2.source:消息源  一个服务的唯一标识
3.type:消息类别
4.message:消息的c指针  对于lua层来说是一个lightuserdata
5.size:消息长度
]]--

--[[
注册特定类消息的处理函数
ex:监听lua类的消息
skynet.dispatch('lua',function(session, source, cmd, ...)
end)
]]
skynet.start(function()
	--print('[LOG]',os.date('%m-%d-%Y %X', skynet.starttime()),'ZY Server:',skynet.self())--自己的服务地址
	skynet.dispatch('lua',function(session,source, cmd,...)
		print('[service zy]:','recieve msg',source, cmd,...)
		-- local f = CMD[cmd]
		-- if f then 
		-- 	skynet.ret(skynet.pack(f(...)))
		-- end 
	end)
	
	skynet.register "zy"
end)
