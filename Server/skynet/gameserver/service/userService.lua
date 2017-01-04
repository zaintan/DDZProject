local skynet = require "skynet"

---------------------------------内部函数
--新建账号
local function newUser(smid)

end 
--随机中文名
local function createRandomName()
end 


---------------------------------消息处理
local CMD = {}
--登录处理  通过smid查询账号信息,不存在则新建账号 -- 返回账号信息
function CMD.login(smid)

end
--修改金币 --返回修改结果
function CMD.changeMoney(newMoney)

end
--进入桌子 --
function CMD.loginTable(tid)

end 
--离开桌子
function CMD.logoutTable(tid)

end 



skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, subcmd, ...)
		local f = assert(CMD[cmd])
		skynet.ret(skynet.pack(f(subcmd, ...)))
	end)

end)
