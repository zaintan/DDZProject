local skynet = require "skynet"
require "skynet.manager"	-- import skynet.register

local redisClientsMgr = require("utils/redisClientsMgr")
local rcm = new(redisClientsMgr)


local redis_name        = "game_redis"  --redis client标识   用于区分不同的redis client
local redis_tid_tag     = "tid_counter" --tid生成器  递增
local redis_tid_base    = 1000          --tid基

local redis_tids_key    = "tidsMap"   --
local redis_info_key    = "tid_"      --uid+部分装饰 构成的 hashmap 的key值前缀(即:部分装饰)

---------------------------------内部函数
--随机中文名
local function createRandomName()
	local buffer = nil 
	--0x80-0x7FF的字符用两个字节表示(中文的编码范围)
	local randIndex = math.random(1,#familyNameMap)
	if #familyNameMap - randIndex > 30 then --单姓
		buffer = utf8.char(math.random( 0x4e00, 0x9fa5),math.random( 0x4e00, 0x9fa5))
	else --复姓
		buffer = utf8.char(math.random( 0x4e00, 0x9fa5))
	end
	return familyNameMap[randIndex]..buffer
end 


--新建账号
local function createUser(smid)
	Log.e("USER SERVICE","[us. create user]")
	local ret = {}
	--生成uid
	local uid = rcm:INCR(redis_name, redis_uid_tag)--INCR
	uid = tonumber(uid) + redis_uid_base -- 
	ret.uid   = uid
	--生成随机名字
	ret.username  = createRandomName()
	
	ret.ontable   = false
	ret.money     = 0

	rcm:HMSET(redis_name, redis_uids_key, smid, uid)
	rcm:HMSET(redis_name, redis_info_key..uid, "name",ret.username, "ontable", ret.ontable, "money", ret.money)
	return  ret
end 


---------------------------------消息处理
local CMD = {}
--登录处理  通过smid查询账号信息,不存在则新建账号 -- 返回账号信息
function CMD.login(info)
	Log.dump("[us.login recv]",info)
	local userinfo = nil 
	--通过smid  从redis查询有无uid
	local uid = rcm:HMGET(redis_name,redis_uids_key, info.smid)

	Log.dump("[us.login rcm hmget]",uid)
	if #uid <= 0 then --无 则需创建新账号
		userinfo = createUser(info.smid)
	else 
		local ret = rcm:HMGET(redis_name, redis_info_key..uid[1], "name", "ontable","money","tid")
		userinfo  = {}
		userinfo.username = ret[1]
		userinfo.ontable  = ret[2]
		userinfo.money    = ret[3]
		userinfo.tid      = ret[4]
	end 
	Log.dump("[us.login redis ret]",userinfo)
	return userinfo
end
--修改金币 --返回修改结果
function CMD.changeMoney(uid,newMoney)

end
--进入桌子 --
function CMD.loginTable(tid)

end 
--离开桌子
function CMD.logoutTable(tid)

end 



skynet.start(function()
	--注册名字
	skynet.register('.gameservice')
	--注册消息处理函数
	skynet.dispatch("lua", function(session, source, cmd, subcmd, ...)
		local f = assert(CMD[cmd])
		skynet.ret(skynet.pack(f(subcmd, ...)))
	end)
	--初始化redis
	local cfg  = require("config/gameServerConfig")
	local succ = rcm:addRedisClient(redis_name,cfg.user_redis)
end)
