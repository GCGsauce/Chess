Object = require 'libraries/classic-master/classic'
Input  = require 'libraries/boipushy-master/Input'
require("util")
require("AssetLoader")

local time = 0
local fpsCount = 0

function love.load()
    if arg[#arg] == "-debug" then require("mobdebug").start() end
	input = Input()
	local object_list = {}
	recursiveEnumerate('objects', object_list)
	requireFiles(object_list)
	
    raw_map_data = loadMaps()
	cave = Map(raw_map_data["larger_map"], 50, 50, 50, 50)
end

function love.mousepressed(x, y, button)
    getTileCoords(x, y, 0, 0)
end

function love.update(dt)
	-- if time + dt >= 1.0 then print(fpsCount)
	-- else time = time + dt fpsCount = fpsCount+1 end
	print(love.timer.getFPS())
	cave:update(dt)
end

function love.draw()
	cave:draw()
end