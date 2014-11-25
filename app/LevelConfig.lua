--关卡配置表

module("LevelConfig", package.seeall)

function getItemData( config  )
	local itemData = ITEM[tonumber(config)]
	if not itemData then
		itemData = ITEM[1]
	end
	return itemData 
end

function getBG_ITEM( config  )
	local itemData = BG_ITEM[tonumber(config)]
	if not itemData then
		itemData = BG_ITEM[1]
	end
	return itemData 
end

function getLIMIT_ITEM( config  )
	local itemData = LIMIT_ITEM[tonumber(config)]
	if not itemData then
		itemData = 100000000000
	end
	return itemData 
end

--通关条件
LIMIT_ITEM = {500, 1000, 1500, 2000, 3000, 5000}

--关卡背景
BG_ITEM = {
	"mineBG1.png",
	"mineBG2.png",
	"mineBG3.png",
	"mineBG4.png",
	"mineBG5.png",
	"mineBG6.png"
}

--矿石图片
pic_path_tab = {
	"gold_small.png",
	"gold_middle.png",
	"gold_large.png",
	"gold_large.png",
	"stone_small.png",
	"stone_middle.png",
	"stone_large.png",
	"secret_small.png",
	"secret_middle.png",
	"secret_large.png"
}

--矿石分布及类型
ITEM={}

ITEM[1]={} 
ITEM[1][1]={pic = pic_path_tab[1], pos = ccp(100, 200), weight = 10, price = 50}
ITEM[1][2]={pic = pic_path_tab[1], pos = ccp(200, 200), weight = 10, price = 50}
ITEM[1][3]={pic = pic_path_tab[1], pos = ccp(300, 200), weight = 10, price = 50}
ITEM[1][4]={pic = pic_path_tab[1], pos = ccp(400, 200), weight = 10, price = 50}
ITEM[1][5]={pic = pic_path_tab[1], pos = ccp(500, 200), weight = 10, price = 50}
ITEM[1][6]={pic = pic_path_tab[2], pos = ccp(100, 100), weight = 50, price = 200}
ITEM[1][7]={pic = pic_path_tab[2], pos = ccp(200, 100), weight = 50, price = 200}
ITEM[1][8]={pic = pic_path_tab[2], pos = ccp(300, 100), weight = 50, price = 200}
ITEM[1][9]={pic = pic_path_tab[2], pos = ccp(400, 100), weight = 50, price = 200}
ITEM[1][10]={pic = pic_path_tab[2], pos = ccp(500, 100), weight = 50, price = 200}