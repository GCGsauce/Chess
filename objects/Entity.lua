
Entity = Object:extend()

function Entity:new(x, y)
    self.positionX = x or 0
    self.positionY = y or 0
end

function Entity:getPosition()
    return self.positionX, self.positionY
end

function Entity:getpositionX()
    return self.positionX
end

function Entity:getpositionY()
    return self.positionY
end