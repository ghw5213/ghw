 local Hero = class("Hero", function()
 	return display.newNode()
 end)

 function Hero:ctor()
 	local png = "minerAction.png"
 	local plist = "minerAction.plist"

 	display.addSpriteFramesWithFile(plist, png)
 	self._sp = display.newSprite("#miner_0701.png")
 	self:addChild(self._sp)
 	self:setContentSize(self._sp:getContentSize())
 end

 --动画开始
 function Hero:startAction()
 	local frames = display.newFrames("miner_0%d.png", 701, 10)
 	local animate = display.newAnimation(frames, 0.1)
 	self._sp:playAnimationForever(animate, 0)
 end

 --动画结束
 function Hero:endAction()
 	self._sp:stopAllActions()
 end

 return Hero