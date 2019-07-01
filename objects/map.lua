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
    self.camX = 100 --the coordinates of the current view of the screen relative to the map. this is the "camera"
    self.camY = 50 --move camera only 1 pixel per second
    self.cam_speed = 1

    input:bind('PAN_RIGHT', 'right')
    input:bind('PAN_LEFT', 'left')
    input:bind('PAN_UP', 'up')
    input:bind('PAN_DOWN', 'down')

    -- local yCoord = 7
    -- local xCoord = 1
    -- for y = 7, 20 do
    --     for x = 1, 16 do
    --         local a, b, c, d = unpack(self.quads[self:getTileQuad(x, y)])
    --         print("x: "..x.." y: "..y)
    --         local quad = love.graphics.newQuad(a, b, c, d, self.image:getDimensions())
    --         local z, v = self:getTileCoordinates(x, y-yCoord+1)
    --         print("z: "..z.." v: "..v)
    --         love.graphics.draw(self.image, quad, z + self.camX, self.camY + v)
    --     end
    -- end
end

function Map:update(dt)
    -- if PAN_RIGHT then 
    --     self.camX = self.camX + self.cam_speed * dt
    -- elseif PAN_LEFT then
    --     self.camX = self.camX - self.cam_speed * dt
    -- end

    -- if PAN_UP then 
    --     self.camY = self.camY + self.cam_speed * dt
    -- elseif PAN_DOWN then
    --     self.camY = self.camY - self.cam_speed * dt
    -- end
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
    local xBot, yBot = xTop + math.ceil(gw/self.tilewidth)-1, yTop + math.ceil(gh/self.tileheight)-1
    
    --only render the map that can be seen from the viewport, not the entire map

    for y = yTop, yBot do
        for x = xTop, xBot do
            local a, b, c, d = unpack(self.quads[self:getTileQuad(x, y)])
            local quad = love.graphics.newQuad(a, b, c, d, self.image:getDimensions())
            local z, v = self:getTileCoordinates(x-xTop+1, y-yTop+1)
            love.graphics.draw(self.image, quad, z, v)
        end
    end
end