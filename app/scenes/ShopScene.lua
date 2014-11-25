local ShopScene = class("ShopScene", function()
	return display.newScene("ShopScene")
	end)

function ShopScene:ctor( )
	--背景
	local bg = display.newSprite("shopBack.png")
	bg:setAnchorPoint(ccp(0, 0))
	bg:setScaleX(display.width/bg:getContentSize().width)
    bg:setScaleY(display.height/bg:getContentSize().height)
    bg:setPosition(ccp(0,0))
    self:addChild(bg, 0)

    --商品列表
    self._index = 1
    self._goods_tab = {
    {types = 1, texture = CCTextureCache:sharedTextureCache():addImage("qianglishui.png")},
    {types = 2, texture = CCTextureCache:sharedTextureCache():addImage("article_2001.png")}
	}

	--当前商品
	local goods = display.newSprite(self._goods_tab[self._index].texture)
	goods:setPosition(ccp(145, 100))
	self:addChild(goods, 0)

	--下一关按钮
	local nextLV_btn = cc.ui.UIPushButton.new({normal="shopArrow.png"}, {scale9=true})
	nextLV_btn:setPosition(ccp(display.width-70, 45))
	self:addChild(nextLV_btn, 0)
	nextLV_btn:onButtonClicked(function ( event )
		MyData.setLevel(MyData.getLevel()+1)
		CCDirector:sharedDirector():replaceScene(gameScene.new())
	end)

	 --向左按钮
    local left_btn = cc.ui.UIPushButton.new({normal = "buyleftbtn.png"}, {scale9 = true})
    left_btn:setPosition(ccp(90, 45))
    self:addChild(left_btn, 0)

    left_btn:onButtonClicked(function(event)
    	 self._index =  self._index + 1
    	 if self._index > #self._goods_tab then
    	 	self._index = 1
    	 end
    	 goods:setTexture(self._goods_tab[self._index].texture)
    end)

    --购买按钮
    local buy_btn = cc.ui.UIPushButton.new({normal = "buypowerbtn.png"}, {scale9 = true})
    buy_btn:setPosition(ccp(left_btn:getPositionX() + 50, 45))
    self:addChild(buy_btn, 0)

    buy_btn:onButtonClicked(function(event)

    end)

    --向右按钮
    local right_btn = cc.ui.UIPushButton.new({normal = "buyrightbtn.png"}, {scale9 = true})
    right_btn:setPosition(ccp(buy_btn:getPositionX() + 50, 45))
    self:addChild(right_btn, 0)

    right_btn:onButtonClicked(function(event)
 		self._index =  self._index - 1
    	 if self._index < 1 then
    	 	self._index = #self._goods_tab
    	 end
    	 goods:setTexture(self._goods_tab[self._index].texture)
    end)


end

function ShopScene:onEnter()
end

function ShopScene:onExit()
end

return ShopScene