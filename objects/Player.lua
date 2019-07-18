require "util"
require "constants"
require "objects.Camera"

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
    --need to modify the tile position to have the player sprite sit at the foot of the tile
    self.positionX = map_reference.positionX + ((xTile-1)*map_reference.tilewidth)+(self.playerWidth/2)
    self.positionY = map_reference.positionY + ((yTile-1)*map_reference.tileheight)
end

function Player:update(dt)
    if INPUT:down('MOVE_RIGHT') then  
        self.positionX = self.positionX + 2
    elseif INPUT:down('MOVE_LEFT') then
        self.positionX = self.positionX - 2
    elseif INPUT:down('MOVE_UP') then 
        self.positionY = self.positionY - 2
    elseif INPUT:down('MOVE_DOWN') then
        self.positionY = self.positionY + 2
    end
end

function Player:draw() --always render the player in the center of the screen
    love.graphics.draw(self.image, self.currQuad, (gw/2)-(self.playerWidth/2), (gh/2)-(self.playerHeight/2))
end