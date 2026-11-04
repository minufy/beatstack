local filters = {
    enemy = {"enemy"},
}

local dists = {
    enemy = TILE_SIZE*0.5,
}

return function (Player)
    function Player:init_collision()

    end

    function Player:update_collision(dt)
        Game:dist(self, filters.enemy, self.col_enemy, dists.enemy)
    end

    function Player:col_enemy(other)
        self:die()
    end

    function Player:die()
        for _ = 1, 4 do
            Game:add(Particle.new(self.x+self.w/2, self.y+self.h/2, math.random(-10, 10), math.random(-10, 10), math.random(6, 12)))
        end
        self.remove = true
        Camera:shake(3)
        -- Audio.play("die")
    end
end
