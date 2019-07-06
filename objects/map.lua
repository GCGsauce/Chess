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
    self.tileScreenWidth = math.ceil(gw/self.tilewidth) --width of the screen in tile map size
    self.tileScreenHeight = math.ceil(gh/self.tileheight)

    input:bind('right', 'PAN_RIGHT')
    input:bind('left', 'PAN_LEFT')
    input:bind('down', 'PAN_DOWN')
    input:bind('up', 'PAN_UP')
end

function Map:update(dt) --moves the map 2 pixels per frame in any direction
    if input:down('PAN_RIGHT') then  
        self.camX = self.camX + 2 * 60 * dt
        --print(self.camX)
    elseif input:down('PAN_LEFT') then
        self.camX = self.camX - 2 * 60 * dt
    end

    if input:down('PAN_UP') then 
        self.camY = self.camY - 2 * 60 * dt
    elseif input:down('PAN_DOWN') then
        self.camY = self.camY + 2 * 60 * dt
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

--(x,y in cartesian coords) determine if position is within the boundaries of the calling map object
function Map:positionInBounds(x, y) 
    if x >= self.positionX and x <= self.positionX +((self.width-1)*self.tilewidth) and y >= self.positionY
    and y <= self.positionY+((self.height-1) * self.tileheight) then return true
    else return false end
end

function Map:draw()	   

    --calculate first x and y tile that is within the viewable viewport if one exists
    local firstX, firstY = math.ceil((self.positionX - self.camX)/self.tilewidth)+1, math.ceil((self.positionY - self.camY)/self.tileheight)+1
    local loopToX, loopToY

    if self:positionInBounds(self.camX + ((firstX-1)*self.tilewidth), self.camY + ((firstY-1)*self.tileheight)) then
        --configure loopToX so that it only draws the visible portion of the map within the viewport
        if firstX+self.width-1 > self.tileScreenWidth then loopToX = self.tileScreenWidth
        else loopToX = firstX+self.width-1 end
        if firstY+self.height-1 > self.tileScreenHeight then loopToY = self.tileScreenHeight 
        else loopToY = firstY+self.width-1 end

        for y = firstY, loopToY do
            for x = firstX, loopToX do
                --print("X: "..x.." Y: "..y)
                local positionX, positionY = self.camX + ((x-1)*self.tilewidth), self.camY + ((y-1)*self.tileheight)
                --print("POSX: "..positionX.." POSY: "..positionY)
                local quadNum = self:getTileQuad(positionX, positionY)
                --print("QUADNUM: "..quadNum)
                local a, b, c, d = unpack(self.quads[quadNum])
                local quad = love.graphics.newQuad(a, b, c, d, self.image:getDimensions())
                love.graphics.draw(self.image, quad, positionX-self.camX, positionY-self.camY)
            end
        end
    end
end