local StartScene = class("StartScene", function()
	return display.newScene("StartScene")
end)

function StartScene:ctor()
	--背景
	local background = CCSprite:create("MainMenu.png")
	background:setPosition(ccp(display.cx, display.cy))
	self:addChild(background)

	--开始按钮
	local startImage = ui.newImageMenuItem({
		image = "PlayMenu.png",
		imageSelected = "PlayMenu.png",
		listener = function()
		CCDirector:sharedDirector():replaceScene(gameScene.new())
	end
		})
	local start = cc.Menu:createWithItem(startImage)
	start:setPosition(ccp(display.width/3-30, display.height/3*2+10))
	self:addChild(start)

	--音乐开关
	local music_btn = cc.ui.UICheckBoxButton.new({
		on = "soundController.png",
		off = "soundController2.png"
		})
	music_btn:setPosition(ccp(60, 40))
	music_btn:onButtonStateChanged(function(event)
		if event.state == "on" then 
			audio.playMusic("backMusic.mp3", true)
		elseif event.state == "off" then 
			audio.stopMusic(true)
		end
	end)
	music_btn:setButtonSelected(true)
	self:addChild(music_btn)
end

function StartScene:onEnter()
end
function StartScene:onExit()
end

return StartScene