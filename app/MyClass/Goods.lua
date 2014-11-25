local Goods = class("Goods", function()
	return display.newNode()
end)

function Goods:ctor(params)
	self._path = params.path
	self._weight = params.weight
	self._price = params.price

	self._sp = display.newSprite(self._path)
	self:addChild(self._sp )

	self:setContentSize(self._sp:getContentSize())
end

return Goods 