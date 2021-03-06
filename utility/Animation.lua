require "util"
Animation = Object:extend()

--frames is basically the chosen quads of the image, times are how long each frame exists for
function Animation:new(entity, frames, times, is_looping)
    self.entity = entity
    self.frames = frames
    self.frame_index = 1
    self.is_looping = is_looping or true
    self.times = times or fillRedundantTable(0.12, #frames) -- default if not specified for each frame is 0.12s
end

function Animation:start()
    self.timer = Timer()
    self.entity.curr_frame = self.frames[self.frame_index]
    
    self.timer:after(self.times[self.frame_index], 
        function(f) 
        if self.frame_index == #self.times then 
            if self.is_looping == false then self:exit() return end
            self.frame_index = 1 else self.frame_index = self.frame_index + 1 end
        self.entity.curr_frame = self.frames[self.frame_index]
        self.timer:after(self.times[self.frame_index], f) end
    ) 
end

function Animation:update(dt)
    if self.timer then 
        self.timer:update(dt)
    end
end

function Animation:exit()
    self.timer:clear()
    self.timer = nil
    self.entity.curr_frame = self.entity.start_frame
    self.entity.curr_animation = nil
end