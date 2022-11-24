-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end


-- Renvoie la distance entre deux points
function math.dist(x1,y1, x2,y2)
    return ((x2-x1)^2+(y2-y1)^2)^0.5
end

-- Retourne l'angle entre deux vecteurs ayant la même origine
function math.angle(x1,y1, x2,y2)
    return math.atan2(y2-y1, x2-x1)
end



local list_sprites = {}
local human = {}
local list_shoots = {}

local ZSTATES = {}
ZSTATES.NONE = ""
ZSTATES.WALK = "walk"
ZSTATES.ATTACK = "attack"
ZSTATES.BITE = "bite"
ZSTATES.CHANGE_DIR = "change"
ZSTATES.HIT = "hit"
ZSTATES.DEAD = "dead"

local alertPic = love.graphics.newImage("images/alert.png")
local viseurPic = love.graphics.newImage("images/viseur.png")
local shootPic = love.graphics.newImage("images/laser1.png")

soundShoot = love.audio.newSource("sons/shoot.wav", "static")
soundHit = love.audio.newSource("sons/hit.wav", "static")



function CreateSprite(pType, pNamePic, pFrames, pX, pY)
    fSprite = {}
    fSprite.type = pType
    fSprite.x = pX
    fSprite.y = pY
    fSprite.vx = 0
    fSprite.vy = 0
    fSprite.delete = false
    
    -- Chargement des frames du sprite
    fSprite.frames = {}
    fSprite.currentFrame = 1
    local iFrame
    for iFrame = 1, pFrames do
        fSprite.frames[iFrame] = love.graphics.newImage("images/"..pNamePic..tostring(iFrame)..".png")
    end
    fSprite.width = fSprite.frames[1]:getWidth()
    fSprite.height = fSprite.frames[1]:getHeight()   

    table.insert(list_sprites, fSprite)

    return fSprite
end



function CreateHuman()
    fHuman = CreateSprite("human", "player_", 4, WIDTH_SCREEN/2, HEIGHT_SCREEN*0.75)
    fHuman.life = 100
    fSprite.isAlive = true
    fSprite.canMove = true
    fHuman.deadPic = love.graphics.newImage("images/dead_1.png")
    fHuman.Hurt = function()
                    fHuman.life = fHuman.life - 0.1
                    if fHuman.life <= 0 then
                        fHuman.life = 0
                        fHuman.isAlive = false
                    end
    end

    return fHuman
end



function CreateZombie()
    fZombie = CreateSprite("zombie", "monster_", 2, 0, 0)
    fZombie.x = math.random(10, WIDTH_SCREEN-10)
    fZombie.y = math.random(10, (HEIGHT_SCREEN/2)-10)

    fSprite.isAlive = true
    fSprite.canMove = true

    fZombie.speed = math.random(5, 50)/100
    fZombie.range = math.random(10, 150)
    fZombie.target = nil

    fZombie.state = ZSTATES.NONE
    fZombie.displayState = false
    fZombie.displayStateSwitch = "off"

    return fZombie
end



function CreatShoot(pX, pY, pSpeedX, pSpeedY)
    local shoot = CreateSprite("shoot", "laser", 1, human.x, human.y)
    table.insert(list_shoots, shoot)

    shoot.speedX = pSpeedX
    shoot.speedY = pSpeedY

    soundShoot:play()
end



function UpdateZombie(pZombie, pEntities)

    ---------------{MACHINE À ÉTATS}---------------
    if pZombie.state == nil then
        print("!!! ERROR STATE NIL !!!")
    end

    if pZombie.state == ZSTATES.NONE then
        pZombie.state = ZSTATES.CHANGE_DIR

    elseif pZombie.state == ZSTATES.WALK then

        ---------------{COLLISIONS AVEC LES MURS}---------------
        local bCollide = false

        if pZombie.x < pZombie.width/2 then                     --[COLLISION MUR GAUCHE] SI ZombiePosX < 0 + ZombieLargeur/2 ALORS repositionnement au bord de l'écran
            pZombie.x = pZombie.width/2
            bCollide = true
        end
        if pZombie.x > (WIDTH_SCREEN - pZombie.width/2) then    --[COLLISION MUR DROITE] SI ZombiePosX > LargeurEcran - ZombieLargeur/2 ALORS repositionnement au bord de l'écran
            pZombie.x = WIDTH_SCREEN - pZombie.width/2
            bCollide = true
        end
        if pZombie.y < pZombie.height/2 then                    --[COLLISION MUR HAUT] SI ZombiePosY < 0 + ZombieHauteur/2 ALORS repositionnement au bord de l'écran
            pZombie.y = pZombie.height/2
            bCollide = true
        end
        if pZombie.y > (HEIGHT_SCREEN - pZombie.height/2) then  --[COLLISION MUR BAS] SI ZombiePosY < HauteurEcran - ZombieHauteur/2 ALORS repositionnement au bord de l'écran
            pZombie.y = HEIGHT_SCREEN - pZombie.height/2
            bCollide = true
        end

        -- changer de direction s'il ya une collision
        if bCollide == true then
            pZombie.state = ZSTATES.CHANGE_DIR
        end

        ---------------{HUMAIN ?}---------------
        local iEntities
        for iEntities, sprite in ipairs(pEntities) do

            -- SI human + vivant ALORS...
            if (sprite.type == "human") and (sprite.isAlive == true) then
                local distance = math.dist(pZombie.x, pZombie.y, sprite.x, sprite.y)

                -- SI distance < portée ALORS attaquer
                if distance < pZombie.range then
                    pZombie.state = ZSTATES.ATTACK
                    pZombie.target = sprite
                end
            end
        end

    elseif pZombie.state == ZSTATES.ATTACK then

        if pZombie.target == nil then
            pZombie.state = ZSTATES.CHANGE_DIR

        elseif (math.dist(pZombie.x, pZombie.y, pZombie.target.x, pZombie.target.y) > pZombie.range) and (pZombie.target.type == "human") then
            pZombie.state = ZSTATES.CHANGE_DIR
        
        elseif (math.dist(pZombie.x, pZombie.y, pZombie.target.x, pZombie.target.y) < 5) and (pZombie.target.type == "human") then
            pZombie.state = ZSTATES.BITE
            pZombie.vx = 0
            pZombie.vy = 0

        else
            ---------------{FAIT TITUBER LE ZOMBIE, À COURTE DISTANCE}---------------
            local destX, destY
            destX = math.random(pZombie.target.x - 10, pZombie.target.x + 10)
            destY = math.random(pZombie.target.y - 10, pZombie.target.y + 10)

            ---------------{POURSUIT L'HUMAIN}---------------
            local angle = math.angle(pZombie.x, pZombie.y, pZombie.target.x, pZombie.target.y)
            pZombie.vx = pZombie.speed * 2 * 60 * math.cos(angle)
            pZombie.vy = pZombie.speed * 2 * 60 * math.sin(angle)
        end

    elseif pZombie.state == ZSTATES.BITE then
        if math.dist(pZombie.x, pZombie.y, pZombie.target.x, pZombie.target.y) > 5 then
            pZombie.state = ZSTATES.ATTACK
        else
            if pZombie.target.Hurt ~= nil then
                pZombie.target.Hurt()
            end
            if pZombie.target.isAlive == false then
                pZombie.state = ZSTATES.CHANGE_DIR
            end
        end

    elseif pZombie.state == ZSTATES.CHANGE_DIR then
        local angle = math.angle(pZombie.x, pZombie.y, math.random(0, WIDTH_SCREEN), math.random(0, HEIGHT_SCREEN))
        pZombie.vx = pZombie.speed * 60 * math.cos(angle)
        pZombie.vy = pZombie.speed * 60 * math.sin(angle)

        pZombie.state = ZSTATES.WALK

    elseif pZombie.state == ZSTATES.HIT then


    elseif pZombie.state == ZSTATES.DEAD then
        

    end
end



function Collide(a1, a2)
    if (a1 == a2) then
        return false
    end
    local dx = a1.x - a2.x
    local dy = a1.y - a2.y
    if (math.abs(dx) < a1.picture:getWidth() + a2.image:getWidth()) then
        if (math.abs(dy) < a1.picture:getHeight() + a2.image:getHeight()) then
            return true
        end
    end
    return false
end



function love.load()
    love.window.setTitle("Zombies Attack")
    --love.window.setMode(1800, 950)

    WIDTH_SCREEN = love.graphics.getWidth() / 2
    HEIGHT_SCREEN = love.graphics.getHeight() / 2

    human = CreateHuman()

    local indexZombie
    for indexZombie = 1, 25 do
        CreateZombie()
    end

    love.mouse.setVisible(false)
end

function love.update(dt)

    ---------------{GESTION DES SHOOTS}---------------
    local iShoot
    for iShoot = #list_shoots, 1, -1 do
        local shoot = list_shoots[iShoot]
        shoot.x = shoot.x + shoot.speedX
        shoot.y = shoot.y + shoot.speedY

        ---------------{SUPPRIMER SPRITE SHOOT ?}---------------
        if ((shoot.x + shoot.width*0.5) < 0) or ((shoot.x - shoot.width*0.5) > WIDTH_SCREEN) or ((shoot.y + shoot.height*0.5) < 0) or ((shoot.y - shoot.height-0.5) > HEIGHT_SCREEN) then
            shoot.delete = true
            table.remove(list_shoots, iShoot)

        end
    end

    ---------------{SUPPRIMER SPRITE}---------------
    local iSprite
    for iSprite = #list_sprites, 1, -1 do
        if list_sprites[iSprite].delete == true then
            table.remove(list_sprites, iSprite)
        end
    end


    ---------------{CALCUL DE FRAME}---------------
    local indexFrame
    for indexFrame, sprite in ipairs(list_sprites) do
        sprite.currentFrame = sprite.currentFrame + 0.1
        if sprite.currentFrame >= #sprite.frames + 1 then
            sprite.currentFrame = 1
        end

        ---------------{CALCUL DE VÉLOCITÉ}---------------
        sprite.x = sprite.x + sprite.vx * dt
        sprite.y = sprite.y + sprite.vy * dt

        -- ajoute les sprites "zombie" en paramètres
        if sprite.type == "zombie" then
            UpdateZombie(sprite, list_sprites)
        end
    end
    
    ---------------{CONTÔLE DU JOUEUR}---------------
    if human.canMove == true then
        if love.keyboard.isDown("z") then
            human.y = human.y - 2
        end
        if love.keyboard.isDown("s") then
            human.y = human.y + 2
        end
        if love.keyboard.isDown("q") then
            human.x = human.x - 2
        end
        if love.keyboard.isDown("d") then
            human.x = human.x + 2
        end
    end
end



function love.draw()

    -- affiche le viseur du flingue du joueur
    love.graphics.draw(viseurPic, (love.mouse.getX()) - (viseurPic:getWidth()/2), (love.mouse.getY()) - (viseurPic:getHeight()/2))

    love.graphics.push()
    love.graphics.scale(2,2)

    love.graphics.print("Life : "..tostring(math.floor(human.life)), 1, 1)

    ---------------{AFFICHE LES PERSONNAGES}---------------
    local indexFrame
    for indexFrame, sprite in ipairs(list_sprites) do

        ---------------{AFFICHE LES PERSONNAGES VIVANT}---------------
        if sprite.isAlive == true then
            local frame = sprite.frames[math.floor(sprite.currentFrame)]
            love.graphics.draw(frame, sprite.x - sprite.width/2, sprite.y - sprite.height/2)

            ---------------{AFFICHE L'ÉTATS DES ZOMBIES}---------------
            if (sprite.type == "zombie") and (sprite.displayState == true) then
                love.graphics.print(sprite.state, sprite.x - 10, sprite.y - sprite.height - 10)
            end

            ---------------{AFFICHE LE POINT D'EXCLAMATION DES ZOMBIES}---------------
            if sprite.state == ZSTATES.ATTACK then
                love.graphics.draw(alertPic, sprite.x - alertPic:getWidth()/2, sprite.y - sprite.height - 2)
            end

        ---------------{AFFICHE LE JOUEUR MORT}---------------
        elseif (sprite.type == "human") and (sprite.isAlive == false) then
            love.graphics.draw(sprite.deadPic, sprite.x, sprite.y)
            sprite.canMove = false

        end

        ---------------{AFFICHER LES TIRS}---------------
        if sprite.type == "shoot" then
            local frame = sprite.frames[math.floor(sprite.currentFrame)]
            love.graphics.draw(frame, sprite.x - sprite.width/2, sprite.y - sprite.height/2)
        end
    end
    
    love.graphics.pop()

    love.graphics.print("Nombre de shoots: "..#list_shoots, 1, HEIGHT_SCREEN*2 - 40)
    love.graphics.print("Nombre de sprites: "..#list_sprites, 1, HEIGHT_SCREEN*2 - 20)
end

function love.keypressed(key)
    if key == "space" then
        local iZombie
        for iZombie, sprite in ipairs(list_sprites) do
            if (sprite.type == "zombie") and (sprite.displayStateSwitch == "off") then
                sprite.displayState = true
                sprite.displayStateSwitch = "on"

            elseif (sprite.type == "zombie") and (sprite.displayStateSwitch == "on") then
                sprite.displayState = false
                sprite.displayStateSwitch = "off"

            end
        end
    end
end

function love.mousepressed(x, y, button, isTouch)

    mouseX = love.mouse.getX() * 0.5
    mouseY = love.mouse.getY() * 0.5
    local vx, vy
    local angle
    angle = math.angle(human.x, human.y, mouseX, mouseY)
    vx = 10 * math.cos(angle)
    vy = 10 * math.sin(angle)

    if human.isAlive == true then
        CreatShoot(human.x, human.y, vx, vy)
    end
end