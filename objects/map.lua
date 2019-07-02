require "util"
require "constants"

Map = Object:extend()

function Map:new(map_data) --put in map data to get information about the map (table containing data about the map).	

	if map_data then -- copies all of the data from map_data and makes it a member of the "map" data table
		for k, v in pairs(map_data) do
			self[k] = v
		end
	end
	self.image = love.graphics.newImage(self.tilesets[1].image:sub(4))
    self.camX = 0 --the coordinates of the current view of the screen relative to the map. this is the "camera"
    self.camY = 0 --move camera only 1 pixel per second

    input:bind('right', 'PAN_RIGHT')
    input:bind('left', 'PAN_LEFT')
    input:bind('down', 'PAN_DOWN')
    input:bind('up', 'PAN_UP')
end

function Map:update(dt) --moves the map 1 pixel in any direction
    if input:down('PAN_RIGHT') then  
        self.camX = self.camX + 1
        print(self.camX)
    elseif input:down('PAN_LEFT') then
        self.camX = self.camX - 1
    end

    if input:down('PAN_UP') then 
        self.camY = self.camY - 1
    elseif input:down('PAN_DOWN') then
        self.camY = self.camY + 1
    end
end

function Map:getTileQuad(x, y) -- x, y is the coordinates in tiles, return the number of the quad associated with this tile 
    return self.layers[1].data[self.width*(y-1) + x] -- account for array starting at 1
end

function Map:getTileCoordinates(x, y) --x,y is the coordinate in tiles, return the coordinates along the x and y axis of the screen
    return self.tilewidth*(x-1), self.tileheight*(y-1)
end

function Map:getTilePoint(x, y) --from coords of tile on x,y axis get the point in terms of number of tiles across each axis
    local xCoords = nil
    local yCoords = nil
    
    if x/self.tilewidth == self.width then xCoords = x/self.tilewidth else xCoords = math.floor(x/self.tilewidth)+1 end
    if y/self.tileheight == self.height then yCoords = y/self.tileheight else yCoords = math.floor(y/self.tileheight)+1 end
    return xCoords, yCoords
end

function Map:draw()	

    --get the position in terms of tiles with respect to the whole map of the top left portion of the camera, then render a full screen from there

    local xTop, yTop = self:getTilePoint(self.camX, self.camY)
    local xBot, yBot = self:getTilePoint(self.camX + gw, self.camY + gh)
    local xCoord, yCoord = self:getTileCoordinates(xTop, yTop)
    local xDiff = self.camX - xCoord --the coordinates may start rendering the top left tile from the middle
    local yDiff = self.camY - yCoord

    --only render the map that can be seen from the viewport, not the entire map

    for y = yTop, yBot do
        for x = xTop, xBot do
            local a, b, c, d = unpack(self.quads[self:getTileQuad(x, y)])
            local quad = love.graphics.newQuad(a, b, c, d, self.image:getDimensions())
            local z, v = self:getTileCoordinates(x-xTop+1, y-yTop+1)
            love.graphics.draw(self.image, quad, z - xDiff, v - yDiff)
        end
    end
end