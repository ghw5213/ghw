local GameScene = class("GameScene", function()
	return display.newScene("GameScene")
	end)

require("app.LevelConfig")
require("app.MyData")

function GameScene:ctor()
	--获取当前关卡数据
	local levelData = LevelConfig.getItemData(MyData.getLevel())

	--背景
	local bg = display.newSprite(LevelConfig.getBG_ITEM(MyData.getLevel()))
	bg:setAnchorPoint(ccp(0, 0))
	bg:setPosition(ccp(0, 0))
	bg:setScale(display.width/bg:getContentSize().width)
	self:addChild(bg)

	--设置时间
	self._times = 60

	self._timesLab = ui.newTTFLabel({
		text = "时间:" .. self._times ,
		size = 20,
		color = ccc3(138, 43, 226)
		})
	self._timesLab:setAnchorPoint(ccp(1, 0.5))
	self._timesLab:setPosition(ccp(display.width-20, display.height-self._timesLab:getContentSize().height))
	self:addChild(self._timesLab)

	--设置金钱
	self._goldenLab = ui.newTTFLabel({
		text = "得分: " .. MyData.getGolden(),
		size = 20,
		color = ccc3(138, 43, 226)
		})
	
	self._goldenLab:setAnchorPoint(ccp(0, 0.5))
	self._goldenLab:setPosition(ccp(10, display.height-self._timesLab:getContentSize().height*2))
	self:addChild(self._goldenLab)

	--过关分数
	self._passLab = ui.newTTFLabel({
		text = "目标分数: " .. LevelConfig.getLIMIT_ITEM(MyData.getLevel()),
		size = 20,
		color = ccc3(138, 43, 226)
		})

	self._passLab:setAnchorPoint(ccp(0, 0.5))
	self._passLab:setPosition(ccp(10, display.height-self._timesLab:getContentSize().height))
	self:addChild(self._passLab)

	--创建矿石
	self.goods_tab = {}
	for k, v in pairs(levelData) do
		local goods = Goods.new({path = v.pic, weight = v.weight, price = v.price})
		goods:setPosition(v.pos)
		self:addChild(goods, 1)
		table.insert(self.goods_tab, goods)
	end

	--创建矿工
	local hero = Hero.new()
	hero:setPosition(ccp(display.cx, display.cy+110))
	self:addChild(hero, 0)

	--创建钩子
	self._hook = Hook.new({
		funcL = function( ... )
			self:startTimerTask()
			hero:startAction()
		end,
		funcBE = function( goods )
			hero:endAction()
			if goods then
				MyData.setGolden(MyData.getGolden()+goods._price)
				self._goldenLab:setString("得分:" .. MyData.getGolden().. "")
			end
		end,
		funcBB = function( goods )
			self:stopTimerTask()

			local index = 0
			for k,v in pairs(self.goods_tab) do
				if v == goods then
					index = k
					break
				end
			end
			if index ~= 0 then
				local time = 1
				if goods then
					time = goods._weight/10+0.1
					self._currentGoods = goods
				end

				local sharedScheduler = CCDirector:sharedDirector():getScheduler()
				self._scheduleGoods = sharedScheduler:scheduleScriptFunc(function (...)
					self:timeDealGoods()
				end, 0.01, false)

				goods:runAction(getSequence({CCDelayTime:create(time), CCCallFunc:create(function(...)
					if self._scheduleGoods then
						CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self._scheduleGoods)
						self._scheduleGoods=nil
					end
                    goods:removeFromParentAndCleanup(true)
                    self._currentGoods = nil
                    
				end	)}))

				table.remove(self.goods_tab, index)
			end
		end
		})
	self._hook:setPosition(ccp(display.cx-3.5, display.cy+90))
	self:addChild(self._hook, 3)
	self._hook:startRotation()

	--创建用于接收触摸事件的层
	local touchLayer = TouchLayer.new({func = function ( ... )
		if not self._hook._launchFlag then
			self._hook:hookLaunch()
		end
	end})
	self:addChild(touchLayer, 0)

	--倒计时
	local sharedScheduler = CCDirector:sharedDirector():getScheduler()
	self._schedule1 = sharedScheduler:scheduleScriptFunc(function(...)
		self:timeDeal1()
		end, 1, false)

	--绳子
	self._scheduleLine = sharedScheduler:scheduleScriptFunc(function ( ... )
		self:drawLine()
	end, 0.01, false)
	self._texture = CCTextureCache:sharedTextureCache():addImage("shengzi.png")
	self._textureSprite = cc.Sprite:createWithTexture(self._texture, CCRectMake(0, 0, 0, 5))
	self._textureSprite:setAnchorPoint(ccp(0, 0.5))
	self._textureSprite:setPosition(ccp(display.cx-3.5, display.cy+90))
	self:addChild(self._textureSprite, 2)

	self._hookLenght = self._hook:getLenght()
end

--绳子
function GameScene:drawLine( ... )
	local x = self._hook:getPositionX()-(display.cx-3.5)
	local y = self._hook:getPositionY()-(display.cy+90)
	local width = math.sqrt(x*x+y*y)
	if width < self._hookLenght then
		width = 0
	else
		width = width - self._hookLenght
	end
	self._textureSprite:setTextureRect(CCRectMake(0, 0, width, 5))
	self._textureSprite:setRotation(self._hook:getRotation()+90)
end
--矿石移动
function GameScene:timeDealGoods( ... )
	self._currentGoods:setPosition(self._hook:getPosition())
end

--开始碰撞检测
function GameScene:startTimerTask( ... )
	local sharedScheduler = CCDirector:sharedDirector():getScheduler()
	self._schedule = sharedScheduler:scheduleScriptFunc(function(...)
		self:timeDeal()
		end, 0.01, false)
end

--停止碰撞检测
function GameScene:stopTimerTask(  )
	local sharedScheduler = CCDirector:sharedDirector():getScheduler()
	if self._schedule then
		sharedScheduler:unscheduleScriptEntry(self._schedule)
		self._schedule = nil
	end
end

--碰撞检测
function GameScene:timeDeal( ... )
	local hPosX = self._hook:getPositionX()
	local hPosY = self._hook:getPositionY()

	for k,v in pairs(self.goods_tab) do
		local posX = v:getPositionX()
		local posY = v:getPositionY()

		if math.abs(hPosX-posX) < v:getContentSize().width*0.25 and math.abs(hPosY-posY) < v:getContentSize().height*0.25 then
			self:stopTimerTask()
			self._hook:setGoods(v)
			self._hook:hookBack()
		end
	end
end

--游戏倒计时
function GameScene:timeDeal1( ... )
	self._times = self._times - 1
	self._timesLab:setString("时间:" .. self._times .. "")
	if  self._times <= 0 then
		self._times = 0
		local sharedScheduler = CCDirector:sharedDirector():getScheduler()
		if self._schedule1 then
			sharedScheduler:unscheduleScriptEntry(self._schedule1)
			self._schedule1 = nil
		end
		self:stopTimerTask()
		
		local scene = nil
		--判断是否过关
		if LevelConfig.getLIMIT_ITEM(MyData.getLevel()) < MyData.getGolden() then
			MyData.setGolden(0)
			scene = shopScene.new()
			if MyData.getLevel() == 6 then
				scene = startScene.new()
			end
		else
			MyData.setGolden(0)
			scene = startScene.new()
		end
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self._scheduleLine)
		CCDirector:sharedDirector():replaceScene(scene)
		if self._scheduleGoods then
			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self._scheduleGoods)
		end
	end
end

function GameScene:onEnter()
end

function GameScene:onExit()
end

return GameScene