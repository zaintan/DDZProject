--poker


local poker = class();

function poker:ctor( ... )
	-- body
	poker.init(self);
end

function poker:dtor( ... )
	-- body
end

function poker:init( ... )
	-- body
	self.m_type = k_poker_type.heart;
	self.m_value = 0;
end

--获取牌的类型
function poker:get_type( ... )
	-- body
	return self.m_type;
end

--获取牌的数值
function poker:get_value( ... )
	-- body
	return self.m_value;
end