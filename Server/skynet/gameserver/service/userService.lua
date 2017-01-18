local skynet = require "skynet"
require "skynet.manager"	-- import skynet.register

local redisClientsMgr = require("utils/redisClientsMgr")
local rcm = new(redisClientsMgr)


local redis_name        = "user_redis"--redis client标识   用于区分不同的redis server
local redis_uid_tag     = "uid_counter"--uid生成器  递增
local redis_uid_base    = 100000        --uid基

local redis_uids_key    = "uidsMap"   --smid与uid组成的 hash map 的key值
local redis_info_key    = "uid_"      --uid+部分装饰 构成的 hashmap 的key值前缀(即:部分装饰)

local familyNameMap = {
'赵','钱','孙','李','周','吴','郑','王','冯','陈','褚','卫','蒋','沈','韩','杨','朱','秦','尤','许','何','吕','施','张','孔','曹','严','华','金','魏','陶','姜',
'戚','谢','邹','喻','柏','水','窦','章','云','苏','潘','葛','奚','范','彭','郎','鲁','韦','昌','马','苗','凤','花','方','俞','任','袁','柳','丰','鲍','史','唐',
'费','廉','岑','薛','雷','贺','倪','汤','滕','殷','罗','毕','郝','邬','安','常','乐','于','时','傅','皮','卞','齐','康','伍','余','元','卜','顾','孟','平','黄',
'和','穆','萧','尹','姚','邵','湛','汪','祁','毛','禹','狄','米','贝','明','臧','计','伏','成','戴','谈','宋','茅','庞','熊','纪','舒','屈','项','祝','董','梁',
'杜','阮','蓝','闵','席','季','麻','强','贾','路','娄','危','江','童','颜','郭','梅','盛','林','刁','钟','徐','丘','骆','高','夏','蔡','田','樊','胡','凌','霍',
'虞','万','支','柯','昝','管','卢','莫','经','房','裘','缪','干','解','应','宗','丁','宣','贲','邓','郁','单','杭','洪','包','诸','左','石','崔','吉','钮','龚',
'程','嵇','邢','滑','裴','陆','荣','翁','荀','羊','於','惠','甄','麴','家','封','芮','羿','储','靳','汲','邴','糜','松','井','段','富','巫','乌','焦','巴','弓',
'牧','隗','山','谷','车','侯','宓','蓬','全','郗','班','仰','秋','仲','伊','宫','宁','仇','栾','暴','甘','钭','厉','戌','祖','武','符','刘','景','詹','束','龙',
'叶','幸','司','韶','郜','黎','蓟','薄','印','宿','白','怀','蒲','邰','从','鄂','索','咸','籍','赖','卓','蔺','屠','蒙','池','乔','阴','郁','胥','能','苍','双',
'闻','莘','党','翟','谭','贡','劳','逢','姬','申','扶','堵','冉','宰','郦','雍','郤','璩','桑','桂','濮','牛','寿','通','边','扈','燕','冀','郏','浦','尚','农',
'温','别','庄','晏','柴','瞿','阎','充','慕','连','茹','习','宦','艾','鱼','容','向','古','易','慎','戈','廖','庾','终','暨','居','衡','步','都','耿','满','弘',
'匡','国','文','寇','广','禄','阙','东','欧','殳','沃','利','蔚','越','菱','隆','师','巩','厍','聂','晃','勾','敖','融','冷','訾','辛','阚','那','简','饶','空',
'曾','毋','沙','乜','养','鞠','须','丰','巢','关','蒯','相','查','后','荆','红','游','竺','权','逯','盖','益','桓','公',
'万俟','司马','上官','欧阳','夏侯','诸葛','闻人','东方','赫连','皇甫','尉迟','公羊','澹台','公冶','宗政',
'濮阳','淳于','单于','太叔','申屠','公孙','仲孙','轩辕','令狐','钟离','宇文','长孙','慕容','司徒','司空'
}

--redis key zhi
local l_redis_key = {
	nick = "nick",
	ontable = "ontable",
	coin = "coin",
	diamond = "diamond",
	tid = "tid",--table id
} 


--处理user 数据
local user_service = class();	

user_service.ctor = function ( self )
	Log.i(Log.tag.user_service, "[user_service]:ctor")
	
end

user_service.dtor = function ( self )
	Log.i(Log.tag.user_service, "[user_service]:dtor")
end


user_service.get_func_by_cmd = function(self, cmd)
	--local func = user_service.cmd_func_map[cmd];
	--assert(func);
	return user_service.cmd_func_map[cmd];--func;
end

--创建一个user 数据
user_service.create_user = function ( self, smid )
	Log.i("[user_service]:create_user"..tostring(simd))
	if not simd then
		return nil;
	end

	local ret = {}
	--生成uid
	local uid = self:generate_userid(); 
	ret.uid   = uid
	--生成随机名字
	ret.username  = self:generate_nick();
	
	ret.ontable   = false
	ret.money     = 0

	self:redis_hset(redis_uids_key, smid, uid)

	self:redis_hmset(redis_info_key..uid, l_redis_key.nik,ret.username, l_redis_key.ontable, ret.ontable, l_redis_key.coin, ret.money)
	return  ret	
end

--生成 userid
user_service.generate_userid = function ( self )
	local uid = self:redis_incr(redis_uid_tag)
	uid = tonumber(uid) + redis_uid_base 
	return uid;
end

--生成随机名字
user_service.generate_nick = function ( self )
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

--修改金币
user_service.modify_coin = function ( self, userid, coin )
	if not userid then
		return;
	end

	coin = tonumber(coin);
	if not coin then
		return;
	end

	self:redis_hset(redis_info_key..userid, l_redis_key.coin, coin)
end


--修改nick
user_service.modify_nick= function ( self, userid, nick )
	if not userid then
		return;
	end

	if type(nick) ~= "string" then
		return;
	end

	self:redis_hset(redis_info_key..userid, l_redis_key.nick, nick)
end



--获取userinfo 通过 userid
user_service.get_user_by_userid = function ( userid )
	--local name = self:redis_hmget(redis_info_key..userid, "name")
end



--登陆回调处理
user_service.respone_login = function(self, data)
	Log.i("[user_service]:respone_login")
	if not data then
		Log.i("[user_service]:data is nil")
		return;
	end

	Log.dump("[recv]",info)

	local userinfo = nil 
	--通过smid  从redis查询有无uid
	local uid = self:redis_hget(redis_uids_key, data.smid)

	Log.dump("[us.login rcm hmget]",uid)
	if #uid <= 0 then --无 则需创建新账号
		userinfo = createUser(data.smid)
	else 
		local ret = self:redis_hmget(redis_info_key..uid[1], l_redis_key.nick, l_redis_key.ontable,l_redis_key.coin,l_redis_key.tid)
		userinfo  = {}
		userinfo.username = ret[1]
		userinfo.ontable  = ret[2] --or false
		userinfo.money    = ret[3]
		userinfo.tid      = ret[4]
	end 
	Log.dump("[us.login redis ret]",userinfo)
	userinfo.ontable = false
	return userinfo
end



--封装redis的相关操作，方便以后修改相关代码
user_service.redis_hmget = function ( self , key, ...)
	local ret = rcm:HMGET(redis_name, key, ...)
	return ret;	
end

--封装redis的相关操作，方便以后修改相关代码
user_service.redis_hmset = function ( self , key, ...)
	rcm:HMSET(redis_name, key, ...)
end

--封装redis的相关操作，方便以后修改相关代码
user_service.redis_hget = function ( self , key, ...)
	local ret = rcm:HGET(redis_name, key, ...)
	return ret;	
end

--封装redis的相关操作，方便以后修改相关代码
user_service.redis_hset = function ( self , key, ...)
	rcm:HSET(redis_name, key, ...)
end

--封装redis的相关操作，方便以后修改相关代码
user_service.redis_incr = function ( self , key)
	rcm:INCR(key)
end





--cmd func map
user_service.cmd_func_map = {
    ["login"] = user_service.respone_login,
};





skynet.start(function()
	math.randomseed(os.clock())
	--注册名字
	skynet.register('.userservice')
	--注册消息处理函数
	skynet.dispatch("lua", function(session, source, cmd, ...);
		local f = user_service:get_func_by_cmd(cmd);
		if f then
			skynet.ret(skynet.pack(f(...)))
		end
	end)
	--初始化redis
	local cfg  = require("config/gameServerConfig")
	local succ = rcm:addRedisClient(redis_name,cfg.user_redis)
    -- test
	-- user_service:redis_hset("test-", "coin", 101)
	-- local coin = user_service:redis_hget("test-", "coin")
	-- Log.i("[test  coin]:",coin)
	-- Log.i("-----")
end)
