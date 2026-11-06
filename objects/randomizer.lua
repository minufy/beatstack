Randomizer = {}
Randomizer.__index = Randomizer

function Randomizer.new()
    local self = setmetatable({}, Randomizer)
    self.queue = {}
    self:fill()
    return self
end

function Randomizer:fill()
    local bag = {unpack(MINO.types)}
    for i = #bag, 2, -1 do
        local j = love.math.random(i)
        bag[i], bag[j] = bag[j], bag[i]
    end
    for _, piece in ipairs(bag) do
        table.insert(self.queue, piece)
    end
end

function Randomizer:check(count)
    while #self.queue < count do
        self:fill()
    end
end

function Randomizer:next()
    self:check(1)
    local piece = table.remove(self.queue, 1)
    self:check(7)
    return piece
end

function Randomizer:peek(count)
    count = count or 5
    self:check(count)
    local result = {}
    for i = 1, count do
        result[i] = self.queue[i]
    end
    return result
end

function Randomizer:reset()
    self.queue = {}
    self:fill()
end

return Randomizer
