Object = require 'libraries.classic-master.classic'
Input  = require 'libraries.boipushy-master.Input'
require("util")
require("AssetLoader")

function love.load()
	input = Input()
	local object_list = {}
	recursiveEnumerate('objects', object_list)
	requireFiles(object_list)
	
    raw_map_data = loadMaps()
	cave = Map(raw_map_data["grass_map"], 16, 16, 16, -53) 
end

function love.update(dt)
	cave:update(dt)
end

function love.draw()	
	cave:draw()
end