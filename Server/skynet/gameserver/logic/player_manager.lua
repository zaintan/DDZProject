--玩家管理器

player_manager = class();

function player_manager.get_instance( )
	if not player_manager.m_instance then
		player_manager.m_instance = new(player_manager);	
	end
	return player_manager.m_instance;
end

function player_manager.ctor( ... )
	-- body
	player_manager.init(self);
end

function player_manager.dtor( ... )
	-- body
end

function player_manager.init( ... )
	-- body
	self.m_players = {};
end
