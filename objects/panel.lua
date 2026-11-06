Panel = {}
Panel.__index = Panel

function Panel.new(x, y)
    local self = setmetatable({}, Panel)
    self.x = x
    self.y = y
    self.minos = {}
    self.shadow = false
    return self
end

function Panel:update_contents(t)
    self.minos = t
end

function Panel:set_shadow(b)
    self.shadow = b
end

function Panel:draw()
    if self.remove then
        return
    end
    for i, mino in ipairs(self.minos) do
        for _, pos in ipairs(MINO.shapes[mino][1]) do
            local x, y = pos[1], pos[2]
            if self.shadow then
                love.graphics.setColor(COLORS.shadow)
            else
                love.graphics.setColor(MINO.colors[mino])
            end
            love.graphics.rectangle("fill", self.x+x*CELL_SIZE, self.y+(y+i*3)*CELL_SIZE, CELL_SIZE, CELL_SIZE)
            Color.reset()
        end
    end
end

return Panel
