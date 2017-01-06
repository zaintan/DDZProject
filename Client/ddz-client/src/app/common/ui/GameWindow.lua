GameWindow = class("GameWindow", BaseView)

function GameWindow:ctor( parentNode, config )
	DebugLog("GameWindow:ctor")
	self.parentNode = parentNode
	self.config = config 
	self.animFlag = false 
	self.animTime = 0.3    --动画时间

	self:init(config)
	self:initEvent()
	self:initView(config.data)   --初始化子类的视图
end

function GameWindow:init( config )
	DebugLog("GameWindow:init")

	--创建底黑边
	-- local bgLayer = cc.ui.UIImage.new("")
	-- bgLayer:setLayoutSize(display.width, display.height)

	--创建view
	self.root = cc.uiloader:load(config.layoutPath)
	local width, height = 0, 0
	self.bg = cc.uiloader:seekNodeByName(self.root, "bg")
	if self.bg ~= nil then 
		width, height = self.bg:getContentSize().width, self.bg:getContentSize().height
	end
	self:setVisible(false)
	self:addChild(self.root)
	self:setPosition(display.width/2, display.height/2)
	PrintLog("屏幕大小，宽：%s，高：%s,窗口的大小是，宽：%s, 高：%s",display.width, display.height, width, height)
	self.parentNode:addChild(self)

	self:setLocalZOrder(config.level)
end

function GameWindow:onShowEnd(  )
	self.animFlag = false
end

function GameWindow:show(  )
	local tmpStyle = self.config.style or WindowStyle.Normal 
	if self.animFlag then   --正在播放动画
		return 
	end
	self.animFlag = true 
	self:setVisible(true)
	PrintLog(string.format("动画效果id:%s", tostring(tmpStyle)))
	if tmpStyle == WindowStyle.Normal then       --no anim
		self:onShowEnd()
	elseif tmpStyle == WindowStyle.Popu then     --popu
		self:setScale(0.3)
		local args = {
			scale = 1, 
			time = self.animTime,
			easing = "backout",
			onComplete = self.onShowEnd,
		}
		transition.scaleTo(self, args)
	end
end

function GameWindow:initEvent(  )
	self:setTouchEnabled(true)    --设置可点击，避免穿透给遮罩
end

function GameWindow:initView( data )
	error("sub class must implement")
end

function GameWindow:updateView( data )
	error("sub class must implement")
end

function GameWindow:onHideEnd(  )
	WindowManager.getInstance():dispatchEvent({name = WindowManager.CLOSE_WINDOW, id = self.config.id, 
		destroyImmediate = self.config.destroyImmediate, level = self.config.level})
	self.animFlag = false
	if not self.config.destroyImmediate then 
		self:setVisible(false)
	else
		self:removeSelf()
	end
end

--[[
	@desc:关闭窗口
	@return ture表示关闭成功 false表示没有关闭
]]
function GameWindow:hide(  )
	local tmpStyle = self.config.style or WindowStyle.Normal
	if self.animFlag then 
		return false
	end
	self.animFlag = true 
	if tmpStyle == WindowStyle.Normal then     --no anim
		self:onHideEnd()
	elseif tmpStyle == WindowStyle.Popu then   --popu
		local args = {
			scale = 0.2, 
			time = self.animTime,
			easing = "backin",
			onComplete = self.onHideEnd,
		}
		transition.scaleTo(self, args)
	end 
	return true 
end

--获得窗口的层级
function GameWindow:getLevel(  )
	return self.config.level 
end

--获取窗口的id
function GameWindow:getId(  )
	return self.config.id 
end

--获取窗口的style
function GameWindow:getStyle(  )
	return self.config.style 
end

--获取parentNode
function GameWindow:getParentNode(  )
	return self.parentNode
end

--返回是否点击遮罩关闭
function GameWindow:getClickBlankClose(  )
	return self.config.clickBlankClose
end

--按返回键是否关闭窗口
function GameWindow:getClickBackClose(  )
	return self.config.clickBackClose 
end