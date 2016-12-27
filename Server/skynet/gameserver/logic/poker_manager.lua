--扑克管理器

poker_manager = class();

function poker_manager.get_instance( )
	if not poker_manager.m_instance then
		poker_manager.m_instance = new(poker_manager);	
	end
	return poker_manager.m_instance;
end

function poker_manager.ctor( ... )
	-- body
	poker_manager.init(self);
end

function poker_manager.dtor( ... )
	-- body
end

function poker_manager.init( ... )
	-- body
	self.m_pokers = {};
end