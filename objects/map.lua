require "util"
require "constants"

Map = Object:extend()

function Map:new(map_data, x, y, deadzones, boundMap) --put in map data to get information about the map (table containing data about the map).	  
	if map_data then -- copies all of the data from map_data and makes it a member of the "map" data table
		for k, v in pairs(map_data) do
			self[k] = v
		end
    end
    
    self.positionX = x or 0
    self.positionY = y or 0
	self.image = love.graphics.newImage(self.tilesets[1].image:sub(4))
    self.camX = GAME_CAMERA.positionX or 0 --the coordinates of the current view of the screen relative to the map. this is the "camera"
    self.camY = GAME_CAMERA.positionY or 0
    self.boundMap = boundMap or true --bound map means camera cannot pan into the outside portion of the map
    self.widthInPixels = self.tilewidth*self.width
    self.heightInPixels = self.tileheight*self.height
    self.deadzones = deadzones or {}
end

function Map:update(dt) --adjusts the camera position.
end

function Map:getTileCoords(tileX, tileY)
    return self.positionX + ((tileX-1)*self.tilewidth), self.positionY + ((tileY-1)*self.tileheight)
end

function Map:getTileFoot(positionX, positionY)
    return positionX + self.tilewidth, positionY
end

function Map:getTileQuad(x, y) -- x, y is in cart coords, return the number of the quad associated with this tile 
    --must find the tile number of the position with respect to the map
    local tileX, tileY
    if x-self.positionX == self.width*self.tilewidth then tileX = self.width
    else tileX = math.floor((x - self.positionX)/self.tilewidth)+1 end

    if y-self.positionY == self.height*self.tileheight then tileY = self.height
    else tileY = math.floor((y - self.positionY)/self.tileheight)+1 end

    return self.layers[1].data[self.width*(tileY-1) + tileX]
end

function Map:goToAndCenter(x, y) --goes to the location upon which x,y is the central focal point of screen
    self.camX = x - (gw - (self.width*self.tilewidth))/2
    self.camY = y - (gh - (self.height*self.tileheight))/2
end

function Map:addDeadzones(x, y, width, height)
    table.insert(self.deadzones, {x, y, width, height})
end

function Map:getDeadzones()
    return self.deadzones
end

function Map:draw()	   
    --get the starting cartesian coordinates of the first tile that can be seen on the screen
    local xOffset, yOffset = 0, 0 -- tile might need to be rendered a bit off-screen, need to apply offset
    local xCoord, yCoord --coordinates of the top left tile to be rendered
    self.camX, self.camY = GAME_CAMERA.positionX, GAME_CAMERA.positionY
    --condition where the top left tile of the camera still lies inside the map's confines
    if self.camX >= self.positionX and self.camX < self.positionX+(2*self.widthInPixels) then 
        xCoord = self.camX
        if self.camX ~= self.positionX then xOffset = abs(self.camX-self.positionX) % self.tilewidth end
    elseif self.camX > self.positionX-gw then
        xCoord = self.positionX
    else return nil end

    if self.camY >= self.positionY and self.camY < self.camY+(2*self.heightInPixels) then
        yCoord = self.camY
        if self.camY ~= self.positionY then yOffset = abs(self.camY-self.positionY) % self.tileheight end
    elseif self.camY > self.positionY-gh then
        yCoord = self.positionY
    else return nil end
    
    local loopToX, loopToY --coordinates we loop towards
    if self.camX + gw > self.positionX + self.widthInPixels then
        loopToX = self.positionX+self.widthInPixels
        if xOffset == 0 then loopToX = loopToX-self.tilewidth end
    else loopToX = self.camX+gw end

    if self.camY + gh > self.positionY + self.heightInPixels then
        loopToY = self.positionY+self.heightInPixels
        if yOffset == 0 then loopToY = loopToY-self.tileheight end
    else loopToY = self.camY+gh end

    local xCount, yCount = 1, 1 --counts the number of tiles we go down/across 

    for y = yCoord, loopToY, self.tileheight do 
        for x = xCoord, loopToX, self.tilewidth do 
            local xDraw, yDraw
            
            if self.camX < self.positionX then xDraw = (x-self.camX) else xDraw = -xOffset+((xCount-1)*self.tilewidth) end
            if self.camY < self.positionY then yDraw = (y-self.camY) else yDraw = -yOffset+((yCount-1)*self.tileheight) end
            
            local quadNum = self:getTileQuad(x, y)

            love.graphics.draw(self.image, self.quads[quadNum], xDraw, yDraw)
            xCount = xCount+1
        end
        xCount = 1
        yCount = yCount+1
    end
end