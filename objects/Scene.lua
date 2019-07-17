--Scenes contain everything renderable within the screen, the map, the enemies, etc
--each scene will have various exits that correspond to a transition to the nex
Scene = Object:extend()

function Scene:new(map, player)
    self.map = map --map should have deadzones specified 
    self.player = player
end

function Scene:update()

end

function Scene:draw()
    self.map:draw()
    self.player:draw()
end