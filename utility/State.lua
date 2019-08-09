State = Object:extend()

-- at its base level a state and an action is just an animation and different states will inherit from 
-- this class and call functions so the entity will perform some behavior

function State:new(actionFn, animation)
    if animation then 
        self.animation = animation
        self.animation:start() end
    self.actionFn = actionFn
end

function State:update(dt)
    if self.animation then self.animation:update() end
end

function State:execute(args)
    self.actionFn(args)
    print("EXECUTING~")
end

function State:exit()
    if self.animation then self.animation:exit() end
end