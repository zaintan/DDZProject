local LoginPopu = class("LoginPopu", GameWindow)

function LoginPopu:ctor( parentNode, config )
	LoginPopu.super.ctor(self, parentNode, config)
	self:addEvent()
end

function LoginPopu:initView( data )
	self.model = data.model 
	self.modelCls = self.model.class

	self.btnClose = cc.uiloader:seekNodeByName(self.root, "btnClose")
	self.conAccount = cc.uiloader:seekNodeByName(self.root, "conAccount")
	self.conAccountSize = self.conAccount:getContentSize()
	self.conPwd = cc.uiloader:seekNodeByName(self.root, "conPwd")
	self.btnLogin = cc.uiloader:seekNodeByName(self.root, "btnLogin")
	self.cbRemember = cc.uiloader:seekNodeByName(self.root, "cbRemember")

	--账号
	local params = {
		image = "common/input_bg.png",
		listener = self.onEditAccount,
		size = cc.size(300, 50),
	}
	local ebAccount = cc.ui.UIInput.new(params)
	ebAccount:setPlaceHolder("请输入账号")
	ebAccount:setPosition(cc.p(self.conAccountSize.width/2, self.conAccountSize.height/2))
	self.conAccount:addChild(ebAccount)
	self.ebAccount = ebAccount

	--密码
	local params = {
		image = "common/input_bg.png",
		listener = self.onEditPwd,
		size = cc.size(300, 50),
	}
	local ebPwd = cc.ui.UIInput.new(params)
	ebPwd:setInputFlag(0)
	ebPwd:setPlaceHolder("请输入密码")
	ebPwd:setPosition(cc.p(self.conAccountSize.width/2, self.conAccountSize.height/2))
	self.conPwd:addChild(ebPwd)
	self.ebPwd = ebPwd

end

function LoginPopu:onEditAccount( event, editBox )
	PrintLog("event:%s, editBox:%s", tostring(event), tostring(editBox))
	if event == "began" then
		PrintLog("start edit")
	-- 开始输入
	elseif event == "changed" then
		PrintLog("changed edit")
	-- 输入框内容发生变化
	elseif event == "ended" then
		PrintLog("ended edit")
	-- 输入结束
	elseif event == "return" then
		PrintLog("return edit")
	-- 从输入框返回
	end
end

function LoginPopu:onEditPwd( event )
	PrintLog("event:%s", tostring(event))
	if event == "began" then
	-- 开始输入
	elseif event == "changed" then
	-- 输入框内容发生变化
	elseif event == "ended" then
	-- 输入结束
	elseif event == "return" then
	-- 从输入框返回
	end
end

function LoginPopu:addEvent(  )
	self.btnClose:onButtonClicked(function (  )
		self:hide()
	end)
	:onButtonPressed(function ( event )
		event.target:setScale(1.2)
	end)
	:onButtonRelease(function ( event )
		event.target:setScale(1.0)
	end)

	self.cbRemember:onButtonStateChanged(function ( event )
		if event.target:isButtonSelected() then --选中
			PrintLog("选中")
		else
			PrintLog("取消选中")
		end
	end)

	self.btnLogin:onButtonClicked(function (  )
		local str = self.ebAccount:getText()
		PrintLog("btnLogin:onButtonClicked:%s", str)
		local data = {}
		data.loginType = GameConstant.LoginType.GUEST
	end)
end

function LoginPopu:updateView( data )
	self.data = data 
end

return LoginPopu