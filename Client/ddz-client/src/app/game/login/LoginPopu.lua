local LoginPopu = class("LoginPopu", GameWindow)

function LoginPopu:ctor( parentNode, config )
	LoginPopu.super.ctor(self, parentNode, config)
	self:addEvent()
end

function LoginPopu:initView( data )
	self.data = data 
	self.btnClose = cc.uiloader:seekNodeByName(self.root, "btnClose")
end

function LoginPopu:addEvent(  )
	self.btnClose:onButtonClicked(function (  )
		self:hide()
	end)
end

function LoginPopu:updateView( data )
	self.data = data 
end

return LoginPopu