local pad = {}
pad.x = 0
pad.y = 0
pad.width = 80
pad.height = 20

local balle = {}
balle.x = 0
balle.y = 0
balle.vx = 0
balle.vy = 0
balle.radius = 15
balle.isGlued = true

local bricks = {}
bricks.color = 0

local level = {}



function Start()
    balle.isGlued = true

    level = {}
    local lines, columns

    for lines = 1, 6 do
        level[lines] = {}
        for columns = 1, 15 do
            bricks.color = math.random(1, 7)
            level[lines][columns] = bricks.color
        end
    end
end



function love.load()
    WIDTH_SCREEN = love.graphics.getWidth()
    HEIGHT_SCREEN = love.graphics.getHeight()

    pad.x = WIDTH_SCREEN/2
    pad.y = HEIGHT_SCREEN - pad.height/2

    bricks.height = 25
    bricks.width = WIDTH_SCREEN/15

    Start()
end



function love.update(dt)
    pad.x = love.mouse.getX()

    if balle.isGlued == true then
        balle.x = pad.x
        balle.y = pad.y - (pad.height/2) - balle.radius
    else
        balle.x = balle.x + (balle.vx * dt)
        balle.y = balle.y + (balle.vy * dt)
    end


    
    ---------- [COLLISION AVEC LES BRIQUES] ----------
    local columns = math.floor(balle.x / bricks.width) + 1
    local lines = math.floor(balle.y / bricks.height) + 1

    if (lines >= 1) and (lines <= #level) and (columns >= 1) and (columns <= 15) then
        if level[lines][columns] >= 1 then
            level[lines][columns] = 0
            balle.vy = 0 - balle.vy
        end
    end
    


    ---------- [COLLISION AVEC LES MURS] ----------
    if balle.x > (WIDTH_SCREEN - balle.radius) then   -- [À DROITE]
        balle.vx = 0 - balle.vx
        balle.x = WIDTH_SCREEN - balle.radius
    end
    if balle.y < (0 + balle.radius) then   -- [EN HAUT]
        balle.vy = 0 - balle.vy
        balle.y = 0 + balle.radius
    end
    if balle.x < (0 + balle.radius) then   -- [À GAUCHE]
        balle.vx = 0 - balle.vx
        balle.x = 0 + balle.radius
    end
    if balle.y > (HEIGHT_SCREEN + balle.radius) then   -- [EN BAS]
        balle.isGlued = true    -- exeptionnelement on replace la balle sur le pad
    end



    ---------- [COLLISION AVEC LE PAD] ----------
    if (balle.x >= (pad.x - pad.width/2)) and (balle.x <= (pad.x + pad.width/2)) and (balle.y >= (pad.y - (pad.height/2) - balle.radius)) then
        balle.y = pad.y - (pad.height/2) - balle.radius
        balle.vx = 0 + balle.vx
        balle.vy = 0 - balle.vy
    end
end



function love.draw()
    ------------------------- [AFFICHER LES BRIQUES] -------------------------
    local lines, columns
    local bricksX, bricksY = 0, 0

    for lines = 1, 6 do
        bricksX = 0
        for columns = 1, 15 do
            if level[lines][columns] == 1 then  -- bleu
                love.graphics.setColor(0, 0, 255)
                love.graphics.rectangle("fill", bricksX + 1, bricksY + 1, bricks.width - 2, bricks.height - 2)   -- affiche une brique
                love.graphics.setColor(255, 255, 255)
            end
            if level[lines][columns] == 2 then  -- vert
                love.graphics.setColor(0, 255, 0)
                love.graphics.rectangle("fill", bricksX + 1, bricksY + 1, bricks.width - 2, bricks.height - 2)   -- affiche une brique
                love.graphics.setColor(255, 255, 255)
            end
            if level[lines][columns] == 3 then  -- rouge
                love.graphics.setColor(255, 0, 0)
                love.graphics.rectangle("fill", bricksX + 1, bricksY + 1, bricks.width - 2, bricks.height - 2)   -- affiche une brique
                love.graphics.setColor(255, 255, 255)
            end
            if level[lines][columns] == 4 then  -- cyan
                love.graphics.setColor(0, 255, 255)
                love.graphics.rectangle("fill", bricksX + 1, bricksY + 1, bricks.width - 2, bricks.height - 2)   -- affiche une brique
                love.graphics.setColor(255, 255, 255)
            end
            if level[lines][columns] == 5 then  -- jaune
                love.graphics.setColor(255, 255, 0)
                love.graphics.rectangle("fill", bricksX + 1, bricksY + 1, bricks.width - 2, bricks.height - 2)   -- affiche une brique
                love.graphics.setColor(255, 255, 255)
            end
            if level[lines][columns] == 6 then  -- rose
                love.graphics.setColor(255, 0, 255)
                love.graphics.rectangle("fill", bricksX + 1, bricksY + 1, bricks.width - 2, bricks.height - 2)   -- affiche une brique
                love.graphics.setColor(255, 255, 255)
            end
            if level[lines][columns] == 7 then  -- blanc
                love.graphics.setColor(255, 255, 255)
                love.graphics.rectangle("fill", bricksX + 1, bricksY + 1, bricks.width - 2, bricks.height - 2)   -- affiche une brique
            end
            bricksX = bricksX + bricks.width
        end
        bricksY = bricksY + bricks.height
    end
    --------------------------------------------------------------------------

    love.graphics.rectangle("fill", pad.x - (pad.width/2), pad.y - (pad.height/2), pad.width, pad.height)   -- affiche le pad
    love.graphics.circle("fill", balle.x, balle.y, balle.radius)   -- affiche la balle
end



function love.mousepressed(x, y, n)
    if balle.isGlued == true then
        balle.isGlued = false
        balle.vx = 200
        balle.vy = -200
    end
end