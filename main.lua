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
	cave = Map(raw_map_data["grass_map"], 16, 16, 16, -53) --181, -53
end

function love.mousepressed(x, y, button)
    --getTileCoords(x, y, 0, 0)
end

function love.update(dt)
	cave:update(dt)
end

function love.draw()	
	--print(love.timer.getFPS())
	cave:draw()
	-- local image = love.graphics.newImage("rpg_indoor.png")
	-- love.graphics.translate(-10,-10) --when positive numbers are entered - coords still start at 0,0 but
	-- 								--scaled so that drawing at 0,0 draws at 20,20.
    -- love.graphics.draw(image, 0, 0)
end