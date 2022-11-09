local display_map = require("display_map")

function love.load()
    love.window.setMode(1024, 768)

    display_map.Load()
end
function love.update(dt)

end
function love.draw()
    display_map.Draw()
end