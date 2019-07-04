require "util"
require "constants"

Map = Object:extend()

function Map:new(map_data, x, y, camX, camY) --put in map data to get information about the map (table containing data about the map).	  
    x = x or 0 -- position where the first tile is drawn to
    y = y or 0
    camX = camX or 0
    camY = camY or 0
	if map_data then -- copies all of the data from map_data and makes it a member of the "map" data table
		for k, v in pairs(map_data) do
			self[k] = v
		end
    end
    
    self.positionX = x -- the position the map is being rendered to...
    self.positionY = y
	self.image = love.graphics.newImage(self.tilesets[1].image:sub(4))
    self.camX = camX --the coordinates of the current view of the screen relative to the map. this is the "camera"
    self.camY = camY
    self.smallerThanScreenWidth = self.width*self.tilewidth < gw
    self.smallerThanScreenHeight = self.height*self.tileheight < gh

    input:bind('right', 'PAN_RIGHT')
    input:bind('left', 'PAN_LEFT')
    input:bind('down', 'PAN_DOWN')
    input:bind('up', 'PAN_UP')

    -- local currXTile, currYTile = self:getTilePoint(self.camX, self.camY)
    -- local xTopTileCoord, yTopTileCoord = self:getTileCoordinates(currXTile, currYTile)
    -- local xDiff, yDiff = self.camX - xTopTileCoord, self.camY - yTopTileCoord
    -- print("currXTile: "..currXTile.." currYTile: "..currYTile)
    -- for y = 1, math.ceil(gw/self.tilewidth)+1 do
    --     for x = 1, math.ceil(gw/self.tilewidth)+1 do
    --         --get the coordinate of the tile and find out if theres a corresponding quad.
    --         print("GETTILEQUAD: "..currXTile + (x-1))
    --         local quadNum = self:getTileQuad(currXTile + (x-1), currYTile + (y-1))  
    --         if quadNum then
    --             print("XMEN: "..x.." YMEN: "..y.."\n")
    --             local a, b, c, d = unpack(self.quads[quadNum])
    --             local quad = love.graphics.newQuad(a, b, c, d, self.image:getDimensions())
    --             --get the coordinates to display the tiles at 
    --             local z, v = self.tilewidth*(x-1)-xDiff, self.tileheight*(y-1) - yDiff
    --             love.graphics.draw(self.image, quad, z, v)
    --         else print("X: "..x.." Y: "..y.."\n") end
    --     end
    -- end

    --self:goToAndCenter(self.camX, self.camY)
end

function Map:update(dt) --moves the map 2 pixels per frame in any direction
    if input:down('PAN_RIGHT') then  
        self.camX = self.camX + 2
        print(self.camX)
    elseif input:down('PAN_LEFT') then
        self.camX = self.camX - 2
    end

    if input:down('PAN_UP') then 
        self.camY = self.camY - 2
    elseif input:down('PAN_DOWN') then
        self.camY = self.camY + 2
    end
end

function Map:getTileQuad(x, y) -- x, y is the coordinates in tiles, return the number of the quad associated with this tile 
    if x >= 1 and y >= 1 and x <= self.width and y <= self.height then
        return self.layers[1].data[self.width*(y-1) + x] end-- account for array starting at 1
end

function Map:getTileCoordinates(x, y) --x,y is the coordinate in tiles, return the coordinates along the x and y axis of the screen
    local xCoord, yCoord
    --if x==0 or y == 0 then print("WHATSKFJ") end
    if x == nil or y==nil then print("HALLWEO") end
    if x >= 1 then xCoord = self.tilewidth*(x-1)
    elseif x < 0 then xCoord = self.tilewidth*x end

    if y >= 1 then yCoord = self.tileheight*(y-1)
    elseif y < 0 then yCoord = self.tileheight*y end
    return xCoord, yCoord
end

function Map:getTilePoint(x, y) --from coords of tile on x,y axis get the point in terms of number of tiles across each axis
    local xCoords, yCoords
    
    if x > 0 then xCoords = math.ceil(x/self.tilewidth)
    elseif x < 0 then xCoords = math.floor(x/self.tilewidth)
    else xCoords = 1 end --x == 0

    if y > 0 then yCoords = math.ceil(y/self.tileheight) 
    elseif y < 0 then yCoords = math.floor(y/self.tileheight) 
    else yCoords = 1 end
    
    if xCoords == 0 then print("X: "..x.." Y: "..y) end
    return xCoords, yCoords
end

function Map:goToAndCenter(x, y) --goes to the location upon which x,y is the central focal point of screen
    self.camX = x - (gw - (self.width*self.tilewidth))/2
    self.camY = y - (gh - (self.height*self.tileheight))/2
end

function Map:draw()	   
    --gets the x and y coordinate location of the top tile (possibly different to the camera location)
    --only renders what's in the view, not necessarily the entire screen.
    local currXTile, currYTile = self:getTilePoint(self.camX, self.camY)    
    print("CURRXTILE: "..currXTile.." CURRYTILE: "..currYTile)
    local xTopTileCoord, yTopTileCoord = self:getTileCoordinates(currXTile, currYTile)
    local xDiff, yDiff = self.camX - xTopTileCoord, self.camY - yTopTileCoord

    for y = 1, math.ceil(gw/self.tilewidth)+1 do
        for x = 1, math.ceil(gw/self.tilewidth)+1 do
            --get the coordinate of the tile and find out if theres a corresponding quad.
            local quadNum = self:getTileQuad(currXTile + (x-1), currYTile + (y-1))
            if quadNum then
                local a, b, c, d = unpack(self.quads[quadNum])
                local quad = love.graphics.newQuad(a, b, c, d, self.image:getDimensions())
                --get the coordinates to display the tiles at 
                local z, v = (self.tilewidth*(x-1)-xDiff) + self.positionX, (self.tileheight*(y-1) - yDiff) + self.positionY
                love.graphics.draw(self.image, quad, z, v)
            end
        end
    end
end