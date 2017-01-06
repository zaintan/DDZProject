local TestPopu = class("TestPopu", GameWindow)

function TestPopu:ctor( parentNode, config )
	TestPopu.super.ctor(self, parentNode, config)
	self:addEvent()
end

function TestPopu:initView( data )
	self.data = data 
	self.btnClose = cc.uiloader:seekNodeByNameFast(self.root, "btnClose")
end

function TestPopu:addEvent(  )
	self.btnClose:onButtonClicked(function (  )
		self:hide()
	end)
end

function TestPopu:updateView( data )
	self.data = data 
end

return TestPopu