require "util"

Camera = Object:extend()

--simply a camera that follows a specific entity and its movements.
function Camera:new()
end

function Camera:update(dt)
    if self.entity then
        self.positionX, self.positionY = focusCoordsToCenter(self.entity.positionX, self.entity.positionY) 
        self.positionX = self.positionX + (PROTAGONIST.width/2) --adjust for the fact we are centering the protagonist
        self.positionY = self.positionY + (PROTAGONIST.height/2)

        --make the sprite evenly balanced in the center width and bottom of the tile
        self.positionX = self.positionX - (abs(self.entity.width - CURRENT_MAP.tilewidth)/2)
        self.positionY = self.positionY - abs(self.entity.height - CURRENT_MAP.tileheight)
    end
end

--places the camera at the center of the target entity
function Camera:follow(entity)
    self.entity = entity
end