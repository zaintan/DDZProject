--[[
	@desc:窗口管理类
]]

WindowManager = class("WindowManager")

--[[
	@desc:窗口动画类型
]]
WindowStyle = {
	Normal = 1,     --没有任何动画
	Popu   = 2,     --缩放动画  
}

--[[
	@desc:窗口层级定义，越小越下方，预留10做扩展
		  层级相同时候，按照先后顺序进行窗口显示，同层级的窗口只允许出现一个
		  层级不同的窗口，按照层级大小显示，会存在遮挡现象
]]
local WindowLevel = {       
	FullScreen = 10,        --全屏窗口,会相互顶替掉
	NormalPopu = 20,        --普通弹窗,放入等待队列
}

--[[
	@desc:窗口id定义，全局唯一
]]
WindowId = {      
	LoginPopu = 1,          --登录弹窗
	-- TestPopu  = 2,          --test
}

--[[
	@desc:窗口配置，所有的窗口都是通过这个配置来添加删除
	@param: clsPath:类名全路径,在app目录下
			layoutPath:布局文件全路径，在res下
			level:窗口层级
			clickBlankClose:点击空白是否关闭窗口
			clickBackClose:点击手机的back键是否关闭窗口
			destroyImmediate:关闭后是否立即销毁窗口，立即销毁则会重新调用initView,不是立即销毁则不执行ctor函数，但会执行updateView
							 建议经常出现的窗口可以常驻内存，否则设置会ture，减少内存消耗
]]
local WindowConfig = {
	[WindowId.LoginPopu] = {clsPath = "app.game.login.LoginPopu", layoutPath = VIEW_PATH .. "LoginPopu.json", 
		level = WindowLevel.NormalPopu, clickBlankClose = true, clickBackClose = true, destroyImmediate = true},
	-- [WindowId.TestPopu] = {clsPath = "app.game.login.TestPopu", layoutPath = "TestPopu.json", 
	-- 	level = WindowLevel.NormalPopu, clickBlankClose = true, clickBackClose = true, destroyImmediate = true},
}

WindowManager.CLOSE_WINDOW = "WM_CLOSE_WINDOW"     --窗口关闭事件

function WindowManager:ctor(  )
	if WindowManager.Instance ~= nil then 
		printError("WindowManager rereate error!")
		return
	end
	WindowManager.Instance = self
	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()

	self.mWindows = {}            --保存每个窗口的表
	self.mOpenedWindows = {}      --正在显示的窗口表
	self.mWaitedWindows = {}      --等待打开的窗口
	self.mMaskBgs = {}            --遮罩背景,key为对应的level-1

	self:addEvent()
end

function WindowManager.getInstance(  )
	if WindowManager.Instance == nil then 
		return WindowManager.new()
	end
	return WindowManager.Instance
end

function WindowManager:addEvent(  )
	self:addEventListener(WindowManager.CLOSE_WINDOW, handler(self, self.closeWindow))
end

--关闭窗口
function WindowManager:closeWindow( eventData )
	DebugLog(string.format("关闭窗口，窗口id是:%s, 立即销毁：%s", tostring(eventData.id), tostring(eventData.destroyImmediate)))
	self.mOpenedWindows[eventData.id] = nil 
	if eventData.destroyImmediate then                   --立即销毁的，置空
		self.mWindows[eventData.id] = nil 
	end
	self:checkWaitedWindows(eventData.level)             --检查在等待打开的窗口
end

--检查等待打开的窗口,相同level的可以依次打开
function WindowManager:checkWaitedWindows( level )
	PrintLog("WindowManager:checkWaitedWindows, waitedWindow:", tostring(self.mWaitedWindows[level]))
	if self.mWaitedWindows[level] ~= nil and #self.mWaitedWindows[level] ~= 0 then 
		local wnd = table.remove(self.mWaitedWindows[level], 1)
		if wnd ~= nil then 
			self:doShowWindow(wnd)
		end
	else
		PrintLog("销毁遮罩，层次为%s", tostring(level - 1))
		if self.mMaskBgs[level - 1] then    --存在遮罩，则删除
			self.mMaskBgs[level - 1]:removeSelf()
			self.mMaskBgs[level - 1] = nil 
		end
	end
end

--[[
	@desc:提供外部的接口，显示某个窗口
	@param:id:窗口id，见windowId
		   data:传入window的数据
		   style:窗口出现动画类型
]]
function WindowManager:showWindow( parentNode, id, data, style )
	--是否已经打开状态
	if self.mOpenedWindows[id] ~= nil then 
		self.mOpenedWindows[id]:updateView(data)
		return
	end

	if self.mWindows[id] == nil then 
		local window = self:createWindow(parentNode, id, style, data)
		self.mWindows[id] = window
	else
		self.mWindows[id]:updateView(data)
	end
	local config = WindowConfig[id]
	local hasSameLevelWnd = self:checkSameLevelWindow(config.level)
	if hasSameLevelWnd then              --相同层级的插入队列中
		if self.mWaitedWindows[config.level] == nil then 
			self.mWaitedWindows[config.level] = {}
		end
		local needReplace, needCloseWndId = self:checkIsReplace(config.level)       --全屏窗口会顶替掉旧窗口
		if not needReplace then 
			local isExist = self:existWaitedWindows(config.level, id)  --检测等待队列是否已经存在了，存在则不重复添加
			if not isExist then 
				table.insert(self.mWaitedWindows[config.level], self.mWindows[id])
			end
		else
			self.mOpenedWindows[needCloseWndId]:hide()
			self:doShowWindow(self.mWindows[id])
		end
	else
		self:doShowWindow(self.mWindows[id])
	end
end

function WindowManager:checkIsReplace( level )
	local needReplace, needCloseWndId = false, 0
	if level == WindowLevel.FullScreen then 
		for k, wnd in pairs(self.mOpenedWindows) do 
			if wnd:getLevel() == level then 
				needReplace = true 
				needCloseWndId = wnd:getId()
				break
			end
		end
	end
	return needReplace, needCloseWndId
end

function WindowManager:existWaitedWindows( level, id )
	local isExist = false 
	if self.mWaitedWindows[level] ~= nil then 
		for k, wnd in ipairs(self.mWaitedWindows[level]) do 
			if wnd:getId() == id then 
				isExist = true 
				break
			end
		end
	end
	return isExist
end

function WindowManager:doShowWindow( wnd )
	local id = wnd:getId()
	self.mOpenedWindows[id] = wnd
	DebugLog(string.format("显示窗口，窗口id是:%s", tostring(id)))
	self:showMaskBg(wnd)
	self.mWindows[id]:show()
end

function WindowManager:showMaskBg( wnd )
	local level = wnd:getLevel()
	local maskBg = self.mMaskBgs[level - 1]
	if maskBg == nil then
		PrintLog("创建遮罩，层次为：%s", tostring(level-1))
		local options = {}
		options.scale9 = true 
		maskBg = cc.ui.UIImage.new("common/mask.png", options)
		maskBg:setLayoutSize(display.width, display.height)
		maskBg:setLocalZOrder(level - 1)
		maskBg:setTouchEnabled(true)
		maskBg:addNodeEventListener(cc.NODE_TOUCH_EVENT, function ( event )
			if event.name == "began" then
				if wnd:getClickBlankClose() then 
					wnd:hide()
				end
			end
		end)
		maskBg:addTo(wnd:getParentNode())
		self.mMaskBgs[level - 1] = maskBg
	end
end

function WindowManager:checkSameLevelWindow( level )
	for id, wnd in pairs(self.mOpenedWindows) do 
		if wnd:getLevel() == level then 
			return true 
		end
	end
	return false 
end

--[[
	@desc:创建窗口
	@param:parentNode:父节点
		   id:窗口id
		   style:窗口出现动画
		   data:传给窗口的数据
]]
function WindowManager:createWindow( parentNode, id, style, data )
	DebugLog("WindowManager:createWindow", string.format("parentNode:%s, id:%s, style:%s", tostring(parentNode), tostring(id), tostring(style)))
	local config = WindowConfig[id]
	if config == nil then 
		DebugLog("WindowManager:createWindow", string.format("not window config, window id:%s", tostring(id)))
		return 
	end
	local cls = require(config.clsPath)
	config.id = id 
	config.style = style 
	config.data = data 
	local window = cls.new(parentNode, config)
	DebugLog(string.format("创建窗口，窗口id是:%s", tostring(id)))
	return window 
end

--找到最上层的窗口
function WindowManager:findUppermostWnd(  )
	local wndId, maxLevel = nil, -999   --表示很低的层次
	for id, wnd in pairs(self.mOpenedWindows) do 
		if wnd:getLevel() > maxLevel then 
			wndId = wnd:getId()
			maxLevel = wnd:getLevel()
		end
	end
	return wndId 
end

--[[
	@desc:监听按下返回键
]]
function WindowManager:onKeyBack(  )
	local wndId = self:findUppermostWnd() 
	if wndId ~= nil then 
		return self.mOpenedWindows[wndId]:hide()
	else
		return false 
	end
end

