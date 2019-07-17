require "util"
require "constants"
require "objects.Camera"
require "GameLoop"

Player = Entity:extend()

--Player cannot be rendered without a corresponding map
function Player:new()
    Player.super.new(self)
    self.image_path = "images/walk_cycle.png"
    self.image = love.graphics.newImage(self.image_path)
    self.playerHeight = 24
    self.playerWidth = 16
    self.animQuads = generateQuads(self.image_path, self.playerWidth, self.playerHeight)
    self.currQuad = self.animQuads[9]

    INPUT:bind('right', 'MOVE_RIGHT')
    INPUT:bind('left', 'MOVE_LEFT')
    INPUT:bind('down', 'MOVE_DOWN')
    INPUT:bind('up', 'MOVE_UP')
end

--sets the position of the player on the map
function Player:setPosition(xTile, yTile, map_reference)
    self.positionX = map_reference.positionX + ((xTile-1)*map_reference.tilewidth)
    self.positionY = map_reference.positionY + ((yTile-1)*map_reference.tileheight)
end

function Player:update(dt)
    if INPUT:down('MOVE_RIGHT') then  
        self.positionX = self.positionX + 2 * 60 * dt
    elseif INPUT:down('MOVE_LEFT') then
        self.positionX = self.positionX - 2 * 60 * dt
    end

    if INPUT:down('MOVE_UP') then 
        self.positionY = self.positionY - 2 * 60 * dt
    elseif INPUT:down('MOVE_DOWN') then
        self.positionY = self.camY + 2 * 60 * dt
    end
end

function Player:draw()
    if self.positionX and self.positionY then 
        love.graphics.draw(self.image, self.currQuad, self.positionX, self.positionY) end
end