-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

scaleZoom = 4

list_sprite = {}

function CreateSprite(pX, pY, pFramesNb)
    fSprite = {}
    fSprite.x = pX
    fSprite.y = pY
    fSprite.vx = 0
    fSprite.vy = 0
    fSprite.scaleX = 1
    fSprite.scaleY = 1

    -- chargement des frames du sprite
    fSprite.frames = {}
    fSprite.framesNb = pFramesNb
    fSprite.currentFrame = 1
    local iFrame
    for iFrame = 1, fSprite.framesNb do
        fSprite.frames[iFrame] = love.graphics.newImage("images/run_"..tostring(iFrame)..".png")
        fSprite.width = fSprite.frames[iFrame]:getWidth()
        fSprite.height = fSprite.frames[iFrame]:getHeight()
    end

    table.insert(list_sprite, fSprite)

    return fSprite
end

function love.load()
    WIDTH_SCREEN = love.graphics.getWidth()/scaleZoom
    HEIGHT_SCREEN = love.graphics.getHeight()/scaleZoom

    player = CreateSprite(WIDTH_SCREEN/2, HEIGHT_SCREEN/2, 10)
    player.vx = player.vx + 1
end

function love.update(dt)

    local iFrame, kSprite
    for iFrame, kSprite in ipairs(list_sprite) do
        kSprite.currentFrame = kSprite.currentFrame + 0.24
        if kSprite.currentFrame > kSprite.framesNb + 1 then
            kSprite.currentFrame = 1
        end
    end
    
    player.x = player.x + player.vx

    -- ecran, bord gauche
    if player.x < (0 + player.width/8) then
        player.vx = 1
        player.scaleX = 1

    -- ecran, bord droit
    elseif player.x > (WIDTH_SCREEN - player.width/8) then
        player.vx = -1
        player.scaleX = -1

    end
end

function love.draw()
    love.graphics.scale(scaleZoom, scaleZoom)

    local iSprite, kSprite
    for iSprite, kSprite in ipairs(list_sprite) do
        local frame = kSprite.frames[math.floor(kSprite.currentFrame)]
        love.graphics.draw(frame, kSprite.x, kSprite.y, 0, kSprite.scaleX, kSprite.scaleY, kSprite.width/2, kSprite.height/2)
    end
end
