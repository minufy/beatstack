Game = {}

require("scenes.base.draw")(Game)
require("scenes.base.physics")(Game)
require("scenes.base.update")(Game)

local spawn_x
local spawn_y

function Game:init()
    Level:init()

    spawn_x = 3
    spawn_y = BOARD_H/2-2

    self:reset()
end

function Game:update(dt)
    if CONSOLE and Input.refresh.pressed then
        Level:refresh()
        self:reset()
    end

    Camera:update(dt)
    self:update_objects(dt)

    if Input.right.pressed then
        self:set_direction(1)
    end
    if Input.left.pressed then
        self:set_direction(-1)
    end
    if Input.right.released and self.direction == 1  then
        if Input.left.down then
            self:set_direction(-1)
        end
    end
    if Input.left.released and self.direction == -1 then
        if Input.right.down then
            self:set_direction(1)
        end
    end
    if Input.right.up and Input.left.up then
        self:set_direction(0)
    end

    if Input.rotate_cw.pressed then
        self:rotate(1)
    end
    if Input.rotate_ccw.pressed then
        self:rotate(-1)
    end
    if Input.rotate_180.pressed then
        self:rotate(2)
    end
    if Input.hard_drop.pressed then
        self:hard_drop()
    end
    if Input.soft_drop.down then
        self:update_sdarr(dt)
    end
    if Input.hold.pressed then
        self:hold()
    end
    if Input.restart.pressed then
        SM:set_fade(function ()
            self:reset()
        end)
    end

    if self.direction ~= 0 then
        self.das_timer = self.das_timer+dt
        if self.das_timer >= SETTINGS.das then
            self:update_arr(Input.soft_drop.down)
        end
    end
end

function Game:draw()
    love.graphics.setColor(COLORS.bg)
    love.graphics.rectangle("fill", 0, 0, Res.w, Res.h)
    Color.reset()

    Shaders.shadow:start()
    Camera:start()

    self:draw_objects()

    Camera:stop()
    Shaders.shadow:stop()
end

---@generic T
---@param o T
---@return T
function Game:add(o)
    local group_name = tostring(o)
    if self.objects[group_name] == nil then
        self.objects[group_name] = {}
    end
    table.insert(self.objects[group_name], o)
    return o
end

function Game:set_direction(dx)
    if self.direction == dx then
        return
    end
    self.direction = dx
    self:reset_x_timers()
    if dx ~= 0 then
        self:move(dx, 0)
    end
end

function Game:update_arr(soft_drop)
    if SETTINGS.arr == 0 then
        for _ = 1, BOARD_W do
            self:move(self.direction, 0)
            if soft_drop then
                self:update_sdarr(0)
            end
        end
        return
    end
    while self.das_timer >= SETTINGS.das + self.arr_time do
        self:move(self.direction, 0)
        self.arr_time = self.arr_time + SETTINGS.arr
    end
end

function Game:update_sdarr(dt)
    if SETTINGS.sdarr == 0 then
        for _ = 1, BOARD_H do
            self:move(0, 1)
        end
    else
        self.sdarr_timer = self.sdarr_timer+dt
        if self.sdarr_timer >= self.sdarr_time then
            self:move(0, 1)
            self.sdarr_time = self.sdarr_time+SETTINGS.sdarr
        end
    end
end

function Game:spawn_mino()
    local mino_type = self.randomizer:next()
    self.mino = self:add(Mino.new(spawn_x, spawn_y, mino_type, self.board))
    self.holded = false
    self.next_panel:update_contents(self.randomizer:peek(5))
    self.hold_panel:set_shadow(false)
end

function Game:move(dx, dy)
    self.mino:move(dx, dy)
end

function Game:rotate(dr)
    self.mino:rotate(dr)
end

function Game:hard_drop()
    self.mino:hard_drop()
    self:spawn_mino()
end

function Game:hold()
    if self.holded then
    	return
    end
    local current_type = self.mino.type
    self.holded = true
    if self.hold_type == nil then
        self.mino:die()
        self:spawn_mino()
    else
        self.mino:die()
        self.mino = self:add(Mino.new(spawn_x, spawn_y, self.hold_type, self.board))
    end
    self.hold_type = current_type
    self.hold_panel:update_contents({self.hold_type})
    self.hold_panel:set_shadow(true)
end

function Game:reset_timers()
    self:reset_x_timers()
    self.sdarr_timer = 0
    self.sdarr_time = 0
end

function Game:reset_x_timers()
    self.das_timer = 0
    self.arr_timer = 0
    self.arr_time = 0
end

function Game:reset()
    self:reset_timers()
    self.direction = 0
    self.objects = {}
    self.randomizer = Randomizer.new()
    self.next_panel = self:add(Panel.new((BOARD_W+1)*CELL_SIZE, spawn_y*CELL_SIZE))
    self.hold_panel = self:add(Panel.new(-CELL_SIZE*5, spawn_y*CELL_SIZE))
    self.board = self:add(Board.new())
    self.hold_type = nil
    self.holded = false
    self:spawn_mino()
end

return Game
