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

--操作时间
local l_k_operate_remain = 8;

-- local l_act_enum = {
-- 	b_pass = 1,
-- 	data = {
-- 		t = 1,
-- 		data = {}
-- 	};
-- };



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
	--玩家列表
	self.m_players = {};
	--当前的操作状态
	self.m_status = l_status.idle;
	--当前的操作玩家act_index
	self.m_act_index = l_act_index.bottom;
	--前一个的操作玩家act_index
	self.m_pre_act_index = self.m_act_index;
	--后一个的操作玩家act_index
	self.m_next_act_index = self.m_act_index;

	--操作倒计时
	self.m_operate_remain = l_k_operate_remain;


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

	self:stop_game_timer();
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
		self.m_pre_act_index = self:get_pre_act_index(act_index);
		self.m_next_act_index = self:get_next_act_index(act_index);
		self.m_act_index = act_index;
	end
end

function game_round:get_pre_act_index(act_index)
	local pre_act_index = act_index - 1;
	if pre_act_index < l_act_index.bottom then
		pre_act_index = l_act_index.left;
	end
	return pre_act_index;
end

function game_round:get_next_act_index(act_index)
	local next_act_index = act_index + 1;
	if next_act_index > l_act_index.left then
		next_act_index = l_act_index.bottom;
	end
	return next_act_index;
end

--操作index自增 
function game_round:get_increase_act_index(act_index)
	act_index = act_index + 1;
	if act_index > l_act_index.left then
		act_index = l_act_index.bottom;
	end

	return act_index;
end

--操作index自减
function game_round:get_decrease_act_index(act_index)
	act_index = act_index - 1;
	if act_index < l_act_index.bottom then
		act_index = l_act_index.left;
	end
	return act_index;
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
function game_round:game_timer_callback( )
	-- 检查游戏是否结束
	if self:check_game_over() then
		self:end();
		return;
	end

	--倒计时减1，<=0新一轮计时
	self.m_operate_remain = self.m_operate_remain - 1;
	if self.m_operate_remain <= 0 then
		--循序标记下一个act_index
		local act_index = self:get_increase_act_index(self.m_act_index);
		self:set_act_index(act_index);

		--broadcast
		self:broadcast_current_act();	

		--重置倒计时	
		self.m_operate_remain = l_k_operate_remain;
	end
end

--检测牌局是否结束
function game_round:check_game_over( )
	return false;
end

--game logic
function game_round:game_logic()

end

--[[处理打牌逻辑
判断打牌相关的所有逻辑
]]
function game_round:deal_poker_logic( operate_data )
	-- body
	if not operate_data then
		return;
	end

end

--处理打牌请求
function game_round:deal_act_request( act_data )
	-- local act_data = {
	-- 	index = 1,
	-- 	b_pass = false,
	-- 	data = {
	-- 			t = 1,
	-- 			data = {}};
	-- 	};
	--检查当前操作请求是否合法
	if self:check_act_invalid() then
		return;
	end

	--玩家操作：pass
	if act_data.b_pass then

	else
		self:deal_poker_logic(act_data.data);	
	end

	--
	if self:check_game_over() then
		self:end();
		return;
	else
		--循序标记下一个act_index
		local act_index = self:get_increase_act_index(self.m_act_index);
		self:set_act_index(act_index);

		--broadcast
		self:broadcast_current_act();
	end

end

--检查当前操作请求是否合法
function game_round:check_act_invalid( act_index )
	act_index = tonumber(act_index);

	--参数无效
	if not act_index then
		return true;
	end

	--当前应该操作的act_index不是要检测的这个act_index
	if self.m_act_index ~= act_index then
		return true;
	end

	return false;
end

--广播通知 即将要操作的玩家
function game_round:broadcast_current_act(  )
	-- body
	local broadcast_data = {};
	--send boradcast_data;
end




