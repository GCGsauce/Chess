Object = require 'libraries.classic-master.classic'
Input  = require 'libraries.boipushy-master.Input'
Entity = require 'objects.Entity'

require("util")
require("AssetLoader")

local object_list = {}
recursiveEnumerate('objects', object_list)
requireFiles(object_list)

MAP_DATA 	= loadMaps() -- loads all data about maps
INPUT 		= Input()
GAME_CAMERA = Camera()
CURRENT_MAP = Map(MAP_DATA["cave"]) -- start in a cave
PROTAGONIST = Player({"images/walk_cycle.png", 16, 24, 9, 16, 5})

function love.load()
	GAME_CAMERA:follow(PROTAGONIST)
end

function love.update(dt)
	--CURRENT_MAP:update(dt)
	PROTAGONIST:update(dt)
	GAME_CAMERA:update(dt)
end

function love.draw()	
	CURRENT_MAP:draw()
	PROTAGONIST:draw()
end