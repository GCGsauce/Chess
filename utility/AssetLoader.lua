require "util"

function loadMaps()
	local tiled_maps = {}
	recursiveEnumerate("tiled_maps", tiled_maps)
	local game_maps = {}

	for _, file in ipairs(tiled_maps) do
		local f = file:sub(1, -5)
		local map = require(f)
		map.quads = generateQuads(map.tilesets[1].image:sub(4), map.tilesets[1].tilewidth, map.tilesets[1].tileheight) --gets the image path, the tile width and the tile height.
		f = f:sub(12)
		game_maps[f] = map
	end
	return game_maps
end