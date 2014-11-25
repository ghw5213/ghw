--游戏数据
module("MyData", package.seeall)

local golden = 0
local level = 1

function setGolden(num)
	golden = num 
end

function getGolden()
	return golden
end

function setLevel( num  )
	level = num
end

function getLevel()
	return level 
end