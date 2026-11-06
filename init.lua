return function ()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setLineStyle("rough")
    Font = love.graphics.newFont("assets/fonts/Galmuri9.ttf", 10)

    Input.refresh = Input.new({"f5"})
    Input.fullscreen = Input.new({"f11"})

    Input.right = Input.new({"right"})
    Input.left = Input.new({"left"})
    Input.rotate_cw = Input.new({"up"})
    Input.rotate_ccw = Input.new({"lctrl"})
    Input.rotate_180 = Input.new({"a"})
    Input.hard_drop = Input.new({"space"})
    Input.soft_drop = Input.new({"down"})
    Input.restart = Input.new({"r"})
    Input.hold = Input.new({"lshift"})

    -- Audio.new("jump")

    Camera.x_damp = 0.1
    Camera.y_damp = 0.1
    Camera.shake_damp = 0.3

    CELL_SIZE = 10

    SETTINGS = {
        das = 7,
        arr = 0,
        sdarr = 0,
    }

    COLORS = {
        bg = Color.hex("#111111"),
        board_bg = Color.hex("#1a1a1a"),
        shadow = Color.alpha(Color.hex("ffffff"), 0.2),
    }

    TILE_SIZE = 16
    TILE_NAMES = {
        "tile",
    }

    DECAL_NAMES = {

    }
end
