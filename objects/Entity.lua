require "util"
--require "StateManager"

local Entity = Object:extend()

-- local def =
-- {
-- image = "walk_cycle.png",
-- width = 16,
-- height = 24,
-- startFrame = 9,
-- tileX = 10,
-- tileY = 2
-- }

function Entity:new(def)
    self.image = def[1]
    self.width = def[2]
    self.height = def[3]
    self.quads = generateQuads(self.image, self.width, self.height)
    self.curr_frame = def[4]
    self.start_frame = self.curr_frame
    self.tileX = def[5]
    self.tileY = def[6]

    if self.tileX and self.tileY then 
        self.positionX, self.positionY = CURRENT_MAP:getTileCoords(self.tileX, self.tileY) end
    
    -- all entities have an idle state and a movement state. each entity will have an input manager function that
    -- decides what state the entity is currently in
    
    --self.state_manager = StateManager() --useless for the player class as I can bind buttons directly to actions
    print("POSX: "..self.positionX.." POSY: "..self.positionY)
end

function Entity:update()
end

function Entity:move(x, y) -- controls movement for 1 frame so pass in how many pixels to move in either direction
    self.positionX = self.positionX + x
    self.positionY = self.positionY + y
end

function Entity:setTilePosition(tileX, tileY)
    self.tileX = tileX 
    self.tileY = tileY
    --this is the cartesian coordinate position of the player in the world, informs the camera which regions of the map to illuminate
    self.positionX, self.positionY = CURRENT_MAP:getTileCoords(self.tileX, self.tileY)
end 

function Entity:getPosition() --gets the cartesian coordinates of the entity
    return self.positionX, self.positionY
end

function Entity:draw() --if no reference to map object exists then cannot draw the entity to the screen
    --draws a tile to the screen at the precise location in the world, should be on the map

    if self.positionX >= GAME_CAMERA.positionX and self.positionX < GAME_CAMERA.positionX + gw and
       self.positionY >= GAME_CAMERA.positionY and self.positionY < GAME_CAMERA.positionY+gh then 
        local z, v = self.positionX-GAME_CAMERA.positionX, self.positionY - GAME_CAMERA.positionY
        z = z + (abs(self.width - CURRENT_MAP.tilewidth)/2)
        v = v + abs(self.height - CURRENT_MAP.tileheight)
        love.graphics.draw(love.graphics.newImage(self.image), self.quads[self.curr_frame], z, v)
    end
end

return Entity