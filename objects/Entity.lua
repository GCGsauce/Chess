
local Entity = Object:extend()

function Entity:new()
end

function Entity:new(x, y)
    self.positionX = x or 0
    self.positionY = y or 0
end

function Entity:getPosition()
    if self.positionX and self.positionY then return self.positionX, self.positionY end
end

function Entity:getpositionX()
    if self.positionX then return self.positionX end
end

function Entity:getpositionY()
    if self.positionY then return self.positionY end
end

return Entity