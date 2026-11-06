Mino = {}
Mino.__index = Mino

MINO = require("data.minos")

function Mino.new(x, y, type, board)
    local self = setmetatable({}, Mino)
    self.x = x
    self.y = y
    self.type = type
    self.rotation = 1
    self.board = board
    return self
end

function Mino:draw()
    if self.remove then
        return
    end
    local shadow_y = self.y
    for _ = 1, BOARD_H do
        if self.board:check_collision(self.type, self.x, shadow_y+1, self.rotation) then
            break
        end
        shadow_y = shadow_y+1
    end
    for _, pos in ipairs(MINO.shapes[self.type][self.rotation]) do
        local x, y = pos[1], pos[2]
        love.graphics.setColor(COLORS.shadow)
        love.graphics.rectangle("fill", (self.x+x)*CELL_SIZE, (shadow_y+y)*CELL_SIZE, CELL_SIZE, CELL_SIZE)
        Color.reset()
    end
    for _, pos in ipairs(MINO.shapes[self.type][self.rotation]) do
        local x, y = pos[1], pos[2]
        love.graphics.setColor(MINO.colors[self.type])
        love.graphics.rectangle("fill", (self.x+x)*CELL_SIZE, (self.y+y)*CELL_SIZE, CELL_SIZE, CELL_SIZE)
        Color.reset()
    end
end

function Mino:move(dx, dy)
    local x, y = self.x+dx, self.y+dy
    if not self.board:check_collision(self.type, x, y, self.rotation) then
        self.x = x
        self.y = y
    end
end

function Mino:rotate(dr)
    local r = (self.rotation+dr-1)%4+1
    for _, kick in ipairs(MINO.get_kicks(self.type, self.rotation, r)) do
        local x = self.x+kick[1]
        local y = self.y+kick[2]
        if not self.board:check_collision(self.type, x, y, r) then
            self.x = x
            self.y = y
            self.rotation = r
            break
        end
    end
end

function Mino:hard_drop()
    self:die()
    for _ = 1, BOARD_H do
        if self.board:check_collision(self.type, self.x, self.y+1, self.rotation) then
            break
        end
        self.y = self.y+1
    end
    self.board:place(self.type, self.x, self.y, self.rotation)
end

function Mino:update(dt)

end

function Mino:die()
    self.remove = true
end

return Mino
