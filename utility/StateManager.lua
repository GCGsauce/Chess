StateManager = Object:extend()

--collection of states that the entity object can potentially be in
function StateManager:new(entity) -- idle, doesn't really do anything so no need to attach a function to it
    self.states = {Walking = entity.move} 
end

-- state will just be a key, e.g. 'walk', and a function to call when that state is in action
function StateManager:add(key, action)
    self.states[key] = action
end

function StateManager:execute(stateKey, args)
    self.states[stateKey](unpack(args))
end