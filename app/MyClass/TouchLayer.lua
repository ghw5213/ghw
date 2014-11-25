--[[
	触摸响应层
]]

local TouchLayer = class ("TouchLayer", function( ... )
	return display.newNode()
end)

function TouchLayer:ctor( params )
	self._func = params.func

	local colorLayer = display.newColorLayer(ccc4(255, 255, 255, 0))
	self:addChild(colorLayer,0)

	--触摸事件
	colorLayer:setTouchSwallowEnabled(true)
	colorLayer:setTouchEnabled(true)
	colorLayer:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
	colorLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function ( event )
		if event.name == "began" then 
			return true
		elseif event.name == "moved" then 
		elseif event.name == "ended" then
			if self._func then
			(self._func)()
			end
			return true
		end
		return false 
	end)
end

return TouchLayer