Board = {}
Board.__index = Board

BOARD_W = 10
BOARD_H = 40

function Board.new()
    local self = setmetatable({}, Board)
    self.x = 0
    self.y = 0
    self.cam_x = Res.w/2-BOARD_W/2*CELL_SIZE
    self.cam_y = Res.h/2-BOARD_H/4*CELL_SIZE-BOARD_H/2*CELL_SIZE
    self.grid = {}
    for _ = 1, BOARD_H do
        local row = {}
        for _ = 1, BOARD_W do
            table.insert(row, nil)
        end
        table.insert(self.grid, row)
    end
    Camera:set(-self.cam_x, -self.cam_y)
    Camera:snap_back()
    return self
end

function Board:draw()
    love.graphics.setColor(COLORS.board_bg)
    love.graphics.rectangle("fill", self.x, self.y+BOARD_H/2*CELL_SIZE, BOARD_W*CELL_SIZE, BOARD_H/2*CELL_SIZE)
    for x = 1, BOARD_W do
        for y = 1, BOARD_H do
            local grid_x = self.x+(x-1)*CELL_SIZE
            local grid_y = self.y+(y-1)*CELL_SIZE
            local grid_cell = self.grid[y][x]
            if (x+y)%2 == 0 and y > BOARD_H/2 then
                love.graphics.setColor(1, 1, 1, 0.03)
                love.graphics.rectangle("fill", grid_x, grid_y, CELL_SIZE, CELL_SIZE)
                Color.reset()
            end
            if grid_cell ~= nil then
                love.graphics.setColor(MINO.colors[grid_cell])
                love.graphics.rectangle("fill", grid_x, grid_y, CELL_SIZE, CELL_SIZE)
                Color.reset()
            end
        end
    end
end

function Board:update(dt)

end

function Board:clear_lines()
    local cleared = 0
    for y = BOARD_H, 1, -1 do
        local row = self.grid[y]
        local full = true
        for x = 1, BOARD_W do
            if row[x] == nil then
                full = false
                break
            end
        end
        if full then
            cleared = cleared+1
        elseif cleared > 0 then
            self.grid[y+cleared] = row
        end
    end
    for y = 1, cleared do
        self.grid[y] = {}
    end
    return cleared
end

function Board:place(type, x, y, rotation)
    for _, pos in ipairs(MINO.shapes[type][rotation]) do
        self.grid[y+pos[2]+1][x+pos[1]+1] = type
    end
    self:clear_lines()
end

function Board:check_collision(type, x, y, rotation)
    for _, pos in ipairs(MINO.shapes[type][rotation]) do
        local mx = x+pos[1]
        local my = y+pos[2]
        local outside_x = mx < 0 or mx >= BOARD_W
        local outside_y = my < 0 or my >= BOARD_H
        if outside_x or outside_y or self.grid[my+1][mx+1] ~= nil then
           	return true
        end
    end
    return false
end

return Board
