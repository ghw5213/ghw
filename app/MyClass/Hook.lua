local Hook = class("Hook", function()
	return display.newNode()
	end)

--[[
	params 参数表
	params.funcL     钩子发射回调
	params.funcBB	 钩子回收开始回调		
	params.funcBE	 钩子回收结束回调
]]

function Hook:ctor( params )
	self.funcL = params.funcL
	self.funcBB = params.funcBB
	self.funcBE = params.funcBE

	self._hook = display.newSprite("hook.png")
	self._hook:setAnchorPoint(ccp(0.5, 1))
	self:addChild(self._hook)
	
end

function Hook:getLenght( ... )
	return self._hook:getContentSize().height
end

--钩子旋转
function Hook:startRotation()
	self:setRotation(-90)
	self._launchFlag = false
	local seq = getSequence({CCRotateBy:create(2, 180), CCRotateBy:create(2, -180)})
	local rep = CCRepeatForever:create(seq)
	self:runAction(rep)
end

--钩子发射
function Hook:hookLaunch()
	self:stopAllActions()
	self._launchFlag = true
	local angle = self:getRotation()
	local move = CCMoveBy:create(1.5, ccp(400*math.sin(math.rad(-angle)), -400*math.cos(math.rad(-angle))))
	self:runAction(move)
	ac_dly_fuc(self, 1.5, function()
		self:hookBack()
	end)

	if self.funcL then 
		(self.funcL)()
	end
	self._hook:setAnchorPoint(ccp(0.5, 0))
end

--钩子返回
function Hook:hookBack()
	self:stopAllActions()

	local time = 1.5
	if self._goods then
		time = self._goods._weight/10
	end
	local move = CCMoveTo:create(time, ccp(display.cx-3.5, display.cy+90))
	local seq = getSequence({move, CCCallFunc:create(function()
		self._hook:setAnchorPoint(ccp(0.5, 1))
		self:startRotation()
		if self.funcBE then
			(self.funcBE)(self._goods)
		end
		self._goods = nil
	end)})
	self:runAction(seq)

	if self.funcBB then
		(self.funcBB)(self._goods)
	end
end

--设置当前捕获的矿石
function Hook:setGoods(goods)
	self._goods = goods
end

--动作队列
function getSequence(tb)
	local array = CCArray:create()
	for k,v in pairs(tb) do
		array:addObject(v)
	end
	local ac_seq = CCSequence:create(array)
	return ac_seq
end

--延时
function ac_dly_fuc(ob, tk, fuc)
	if not ob then
		print("common ac_dly_fuc ob is nil value")
	end
	local ac_dly = CCDelayTime:create(tk)
	local ac_fuc = CCCallFuncN:create(fuc)
	local ac_seq = CCSequence:createWithTwoActions(ac_dly, ac_fuc)

	ob:runAction(ac_seq)
end

return Hook