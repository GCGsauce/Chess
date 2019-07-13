Camera = Object:extend()

--simply a camera that follows a specific entity and its movements.
function Camera:new(entity)
    self.x = entity:getPositionX()
    self.y = entity:getPositionY()
end

--attach camera to a specific entity, will focus on this entity and its movement 
function Camera:attach(entity)

end

function Camera:update()
end

--centers the camera around specific coordinates
function Camera:focus(x, y)
    self.x = x-(gw/2)
    self.y = x-(gh/2)
end