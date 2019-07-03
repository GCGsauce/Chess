Object = require 'libraries/classic-master/classic'
Input  = require 'libraries/boipushy-master/Input'
require("util")
require("AssetLoader")

function love.load()
	input = Input()
	local object_list = {}
	recursiveEnumerate('objects', object_list)
	requireFiles(object_list)
	
    raw_map_data = loadMaps()
	cave = Map(raw_map_data["larger_map"], 32, 0)
end

function love.mousepressed(x, y, button)
    getTileCoords(x, y, 0, 0)
end

function love.keypressed(key, u)
	if key == '5' then
		debug.debug()
	end
end

function love.update(dt)
	cave:update(dt)
end

function love.draw()
	cave:draw()
end