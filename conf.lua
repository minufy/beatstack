WINDOW_W = 400
WINDOW_H = 300
CONSOLE = os.getenv("CONSOLE") == "true"
FPS_LIMIT = 120

function love.conf(t)
    t.window.resizable = true
    t.console = CONSOLE
    t.window.width = WINDOW_W*2
    t.window.height = WINDOW_H*2
    t.window.vsync = 0
end
