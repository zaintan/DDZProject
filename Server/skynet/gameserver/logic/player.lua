--player 玩家类


local player = class();

function player.ctor( ... )
	-- body
	player.init(self);
end

function player.dtor( ... )
	-- body
end

function player.init( ... )
	-- body
	self.m_pokers = {};
	self.m_b_landlord = false;--是否是地主
end