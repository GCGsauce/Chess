--require "objects.Entity"
require "util"

Camera = Object:extend()

--simply a camera that follows a specific entity and its movements.
function Camera:new()
end

function Camera:update(dt)
    if self.entity then
        self.positionX, self.positionY = focusCoordsToCenter(self.entity:getPosition()) end
end

--places the camera at the center of the target entity
function Camera:follow(entity)
    self.entity = entity
end