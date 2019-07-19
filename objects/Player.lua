require "util"
require "constants"
require "objects.Camera"

Player = Entity:extend()

--Player cannot be rendered without a corresponding map
function Player:new(def)
    Player.super.new(self, def)

    INPUT:bind('right', 'MOVE_RIGHT')
    INPUT:bind('left', 'MOVE_LEFT')
    INPUT:bind('down', 'MOVE_DOWN')
    INPUT:bind('up', 'MOVE_UP')
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

function Player:draw() --always render the player in the center of the screen, thus overriding entity draw method
    love.graphics.draw(love.graphics.newImage(self.image), self.quads[self.start_frame], (gw/2)-(self.width/2), (gh/2)-(self.height/2))
end