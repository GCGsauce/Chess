require "util"
require "Constants"
require "objects.Camera"
require "utility.Animation"

Player = Entity:extend()

--Player cannot be rendered without a corresponding map
function Player:new(def) 
    Player.super.new(self, def)
    
    move_up = Animation(self, {1, 2, 3, 4})
    move_right = Animation(self, {5, 6, 7, 8})
    move_down = Animation(self, {9, 10, 11, 12})
    move_left = Animation(self, {13, 14, 15, 16})

    --movement_state_up = State(function() self:move(0, -1) end, move_up)

    self.curr_animation = nil
    INPUT:bind('right', 'MOVE_RIGHT')
    INPUT:bind('left', 'MOVE_LEFT')
    INPUT:bind('down', 'MOVE_DOWN')
    INPUT:bind('up', 'MOVE_UP')
end

function Player:update(dt)
    if self.curr_animation ~= nil then 
        self.curr_animation:update(dt) 
    end

    if INPUT:down('MOVE_RIGHT') then self:move(1, 0) new_animation = move_right
    elseif INPUT:down('MOVE_LEFT') then self:move(-1, 0) new_animation = move_left
    elseif INPUT:down('MOVE_UP') then self:move(0, -1) new_animation = move_up
    elseif INPUT:down('MOVE_DOWN') then self:move(0, 1) new_animation = move_down end

    if self.curr_animation ~= new_animation and new_animation ~= nil then
        if self.curr_animation then self.curr_animation:exit() end
        self.curr_animation = new_animation   
        self.curr_animation:start() end
end

function Player:draw() --always render the player in the center of the screen, thus overriding entity draw method
    love.graphics.draw(love.graphics.newImage(self.image), self.quads[self.curr_frame], (gw/2)-(self.width/2), (gh/2)-(self.height/2))
end