--gameRound
--单局的状态管理 开始游戏,洗牌,发牌,操作处理..定地主.

--require

--定时器
local timer_manager = require("utils/schedulerMgr")

--状态枚举
local l_status = {
	idle = 1,--空闲的
	shuffle = 2, --洗牌
	deal_poker = 3, --发牌
	select_landlord = 4, --选地主
	game = 5,--打牌中
	max = 6,--添加状态时，max 请自动加1
}

--操作index
local l_act_index = {
	bottom = 0,
	right = 1,
	left = 2,
};

local game_round = class();	

--ctor
function game_round:ctor()
	-- body
	Log.i(Log.tag.game_round, "[game_round]:ctor")

	game_round.init(self);
end

--ctor
function game_round:dtor()
	-- body
	Log.i(Log.tag.game_round, "[game_round]:dtor")
end

--init
function game_round:init()
	-- body
	Log.i(Log.tag.game_round, "[game_round]:init")
	self.m_players = {};
	self.m_status = l_status.idle;
	self.m_act_index = l_act_index.bottom;
	


end

--洗牌
function game_round:shuffle()
	-- body
	Log.i(Log.tag.game_round, "[game_round]:shuffle")
end

--发牌
function game_round:deal_poker()
	-- body
	Log.i(Log.tag.game_round, "[game_round]:shuffle")
end

--操作
function game_round:operate()
	-- body
	Log.i(Log.tag.game_round, "[game_round]:operate")
end

--选地主
function game_round:select_landlord()
	-- body
	Log.i(Log.tag.game_round, "[game_round]:select_landlord")
end

--玩家进入
function game_round:player_enter(  )
	-- body
	Log.i(Log.tag.game_round, "[game_round]:player_enter")
end

--玩家进入
function game_round:player_exit(  )
	-- body
	Log.i(Log.tag.game_round, "[game_round]:player_enter")
end

--牌局开始
function game_round:start( ... )
	-- body
	Log.i(Log.tag.game_round, "[game_round]:start")
end

--牌局结束
function game_round:end( ... )
	-- body
	Log.i(Log.tag.game_round, "[game_round]:end")
end

--获取当前状态
function game_round:get_status( ... )
	-- body
	return self.m_status;
end

--设置状态
function game_round:set_status( status )
	-- body
	status = tonumber(status)
	if status and ( status >= l_status.idle and status < l_status.max ) then
		self.m_status = status;
	end
end

--获取当前操作index
function game_round:get_act_index(  )
	-- body
	return self.m_act_index;
end

--设置当前操作index
function game_round:set_act_index( act_index )
	Log.i(Log.tag.game_round, "[game_round]:set_act_index :"..tostring(act_index))

	act_index = tonumber(act_index)
	if act_index and ( act_index >= l_act_index.bottom and act_index <= l_act_index.left ) then
		self.m_act_index = act_index;
	end
end

--操作index自增 
function game_round:increase_act_index()
	self.m_act_index = self.m_act_index + 1;
	if self.m_act_index > l_act_index.left then
		self.m_act_index = l_act_index.bottom;
	end
end

--操作index自减
function game_round:decrease_act_index()
	self.m_act_index = self.m_act_index - 1;
	if self.m_act_index < l_act_index.bottom then
		self.m_act_index = l_act_index.left;
	end
end

--启动game定时器
function game_round:start_game_timer( ... )
	Log.i(Log.tag.game_round, "[game_round]:start_game_timer")

	if self.m_timer_game then
		self:stop_game_timer();
	end
	local intaval = 0;
	local times = 0;
	local delay = 0;
	self.m_timer_game = timer_manager:register( self.game_timer_callback, intaval, times, delay,  self)

	Log.i(Log.tag.game_round, "[game_round]:start_game_timer :"..tostring(self.m_timer_game))
end

--停止game定时器
function game_round:stop_game_timer()
	Log.i(Log.tag.game_round, "[game_round]:stop_game_timer"..tostring(self.m_timer_game))

	if self.m_timer_game then
		timer_manager:unregister(self.m_timer_game);
		self.m_timer_game = nil;
	end
end

--game_tiemr 回调函数
function game_round.game_timer_callback( )
	-- body
end

--检测牌局是否结束
function game_round:check_game_over( )
	return false;
end





