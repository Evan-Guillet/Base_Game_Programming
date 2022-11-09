love.graphics.setDefaultFilter("nearest")   -- Empèche Love de filtrer les contours des images quand elles sont redimentionnées

local Game = require("game")

-- Renvoie la distance entre deux points
function math.dist(x1, y1, x2, y2)
    return ((x2-x1)^2+(y2-y1)^2)^0.5
end

function love.load()
    love.window.setMode(1024, 768)

    Game.Load()
end
function love.update(dt)
    Game.Update(dt)
end
function love.draw()
    Game.Draw()
end