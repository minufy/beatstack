Game = {}

require("scenes.base.draw")(Game)
require("scenes.base.physics")(Game)
require("scenes.base.update")(Game)

function Game:init(level)
    self.current_level = level or 1
    Level:init()
    self:reset()
end

function Game:update(dt)
    if CONSOLE and Input.refresh.pressed then
        Level:refresh()
        self:reset()
    end

    Camera:update(dt)
    self:update_objects(dt)
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

function Game:reset()
    self.objects = {}
    Level:load_level(tostring(self.current_level), self)
end

return Game
