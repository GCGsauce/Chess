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
    self.widthInPixels = self.tilewidth*self.width
    self.heightInPixels = self.tileheight*self.height

    input:bind('right', 'PAN_RIGHT')
    input:bind('left', 'PAN_LEFT')
    input:bind('down', 'PAN_DOWN')
    input:bind('up', 'PAN_UP')
end

function Map:update(dt) --moves the map 2 pixels per frame in any direction
    if input:down('PAN_RIGHT') then  
        self.camX = self.camX + 2
    elseif input:down('PAN_LEFT') then
        self.camX = self.camX - 2
    end

    if input:down('PAN_UP') then 
        self.camY = self.camY - 2
    elseif input:down('PAN_DOWN') then
        self.camY = self.camY + 2
    end
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

function Map:move()
    self.camX = self.camX+2
end

function Map:draw()	   
    --get the starting cartesian coordinates of the first tile that can be seen on the screen
    local xOffset, yOffset = 0, 0 -- tile might need to be rendered a bit off-screen, need to apply offset
    local xCoord, yCoord --coordinates of the top left tile to be rendered

    --print("SELF.CAMX: "..self.camX.." SELF.CAMY: "..self.camY)
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

    --print("LOOPTOX: "..loopToX.." LOOPTOY: "..loopToY)
    --print("XOFFSET "..xOffset.." YOFFSET: "..yOffset)

    local xCount, yCount = 1, 1 --counts the number of tiles we go down/across 

    for y = yCoord, loopToY, self.tileheight do 
        for x = xCoord, loopToX, self.tilewidth do 
            local quadNum = self:getTileQuad(x, y)
            local a, b, c, d = unpack(self.quads[quadNum])
            local quad = love.graphics.newQuad(a, b, c, d, self.image:getDimensions())
            --print("X: "..x.." Y: "..y)
            local xDraw, yDraw
            
            if self.camX < self.positionX then xDraw = (x-self.camX) else xDraw = -xOffset+((xCount-1)*self.tilewidth) end
            if self.camY < self.positionY then yDraw = (y-self.camY) else yDraw = -yOffset+((yCount-1)*self.tileheight) end
            
            love.graphics.draw(self.image, quad, xDraw, yDraw)
            xCount = xCount+1
        end
        xCount = 1
        yCount = yCount+1
    end
end