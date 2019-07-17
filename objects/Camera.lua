--require "objects.Entity"
require "util"

Camera = Entity:extend()

--simply a camera that follows a specific entity and its movements.
function Camera:new()
    Camera.super.new(self)
end

function Camera:update(dt)
    if self.entity then
        self.positionX, self.positionY = focusCoordsToCenter(self.entity:getPosition()) end
end

--places the camera at the center of the target entity
function Camera:follow(entity)
    self.entity = entity
end

-- --centers the camera around specific coordinates
-- function Camera:focus(x, y)
--     self.positionX = x-(gw/2)
--     self.positionY = x-(gh/2)
-- end