--gameRound
--单局的状态管理 开始游戏,洗牌,发牌,操作处理..定地主.

--require


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
end



