Object = require 'libraries/classic-master/classic'
Input  = require 'libraries/boipushy-master/Input'
require("util")
require("AssetLoader")

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
	cave:update(dt)
end

function love.draw()	
	print(love.timer.getFPS())
	cave:draw()
end