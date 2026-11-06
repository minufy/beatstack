Mino = {}
Mino.__index = Mino

MINO = require("data.minos")

function Mino.new(x, y, type)
    local self = setmetatable({}, Mino)
    self.x = x
    self.y = y
    self.type = type
    self.rotation = 1
    return self
end

function Mino:draw()
    for _, pos in ipairs(MINO.shapes[self.type][self.rotation]) do
        local x, y = pos[1], pos[2]
        love.graphics.setColor(MINO.colors[self.type])
        love.graphics.rectangle("fill", (self.x+x)*CELL_SIZE, (self.y+y)*CELL_SIZE, CELL_SIZE, CELL_SIZE)
        Color.reset()
    end
end

function Mino:move(board, dx, dy)
    local x, y = self.x+dx, self.y+dy
    if not board:check_collision(self.type, x, y, self.rotation) then
        self.x = x
        self.y = y
    end
end

function Mino:rotate(board, dr)
    local r = (self.rotation+dr-1)%4+1
    for _, kick in ipairs(MINO.get_kicks(self.type, self.rotation, r)) do
        local x = self.x+kick[1]
        local y = self.y+kick[2]
        if not board:check_collision(self.type, x, y, r) then
            self.x = x
            self.y = y
            self.rotation = r
            break
        end
    end
end

function Mino:update(dt)

end

return Mino
