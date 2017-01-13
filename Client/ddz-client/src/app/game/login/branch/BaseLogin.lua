local BaseLogin = class("BaseLogin")

function BaseLogin:ctor(  )
	
end

function BaseLogin:getType(  )
	error("sub class must implement")
end

function BaseLogin:login(  )
	error("sub class must implement")
end

return BaseLogin