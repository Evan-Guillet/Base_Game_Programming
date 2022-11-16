-- bloque le filtrage des images quand elles sont redimensionné
love.graphics.setDefaultFilter("nearest")

math.randomseed(love.timer.getTime())

spaceship = {} -- tableau

---------------{GAME}---------------
game = {}
game.energySpaceship = 0
game.bossMoveX = false
game.nbEnemyKill = 0
game.totalPoint = 0



-- listes d'éléments
list_sprites = {}
list_shoots = {}
list_enemy = {}

soundShoot = love.audio.newSource("sons/shoot.wav", "static")
explodeSound = love.audio.newSource("sons/explode_touch.wav", "static")



---------------{LEVEL 16x12}---------------
level = {}
level = {
            { 0,3,3,3,3,0,0,0,0,0,0,0,0,0,0,0 },
            { 0,3,3,3,3,0,0,0,0,0,0,0,0,0,0,0 },
            { 0,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3 },
            { 0,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3 },
            { 0,4,4,4,4,4,4,4,3,3,3,3,3,3,3,3 },
            { 0,0,0,0,0,0,0,0,3,3,3,3,3,3,3,3 },
            { 0,0,0,0,0,0,0,0,3,3,3,3,3,3,4,4 },
            { 0,0,0,0,0,0,0,0,3,3,3,3,3,3,0,0 },
            { 0,0,0,0,0,0,0,0,3,3,3,3,3,3,0,0 },
            { 0,0,0,0,0,0,0,0,3,3,3,3,3,3,0,0 },
            { 0,3,3,3,3,3,3,3,3,3,3,3,3,3,0,0 },
            { 0,3,3,3,3,3,3,3,3,3,3,3,3,3,0,0 },
            { 0,3,3,3,3,3,3,3,3,3,4,4,4,4,0,0 },
            { 0,3,3,3,3,3,3,3,3,3,0,0,0,0,0,0 },
            { 0,4,4,4,4,4,3,3,3,3,0,0,0,0,0,0 },
            { 0,0,0,0,0,0,3,3,3,3,0,0,0,0,0,0 },
            { 0,0,0,0,0,0,3,3,3,3,0,0,0,0,0,0 },
            { 0,0,0,0,0,0,3,3,3,3,3,3,3,3,0,0 },
            { 0,0,0,0,0,0,3,3,3,3,3,3,3,3,0,0 },
            { 0,0,0,0,0,0,4,4,4,4,4,4,4,4,0,0 },
            { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 },
            { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 },
            { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 },
            { 0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0 },
            { 0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0 },
            { 0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0 },
            { 0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0 },
            { 0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0 },
            { 0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0 },
            { 0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0 },
            { 0,1,1,1,1,1,1,2,2,2,2,2,1,1,0,0 },
            { 0,1,1,1,1,1,1,0,0,0,0,0,1,1,0,0 },
            { 0,1,1,1,1,2,2,0,0,0,0,0,2,2,0,0 },
            { 0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0 },
            { 0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0 },
            { 0,2,2,2,2,0,0,0,0,0,0,0,0,0,0,0 },
            { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 },
            { 0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0 },
            { 0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0 },
            { 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0 },
            { 0,1,1,1,1,1,1,1,1,1,1,1,2,2,2,0 },
            { 0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0 },
            { 0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0 },
            { 0,2,2,2,2,2,2,2,2,2,2,2,0,0,0,0 },
        }



---------------{CAMÉRA}---------------
camera = {}
camera.y = 0
camera.speed = 1



---------------{AFFICHAGE ÉCRAN}---------------
display_screen = "menu"

win = false
timerWin = 0

menuPicture = love.graphics.newImage("images/menu.jpg")
gameOverPicture = love.graphics.newImage("images/gameover.jpg")
gameWinPicture = love.graphics.newImage("images/victory.jpg")



---------------{CHARGEMENT DES TILES}---------------
tilesMap = {}
local indexMap
for indexMap = 1, 4 do
    tilesMap[indexMap] = love.graphics.newImage("images/tile_"..indexMap..".png")
end



---------------{CHARGEMENT DES EXPLOSIONS}---------------
explodeSprites = {}
local n
for n = 1, 5 do
    explodeSprites[n] = love.graphics.newImage("images/explode_"..n..".png")
end



function math.angle(x1,y1, x2,y2)
    return math.atan2(y2-y1, x2-x1)
end



function collide(a1, a2)
    if (a1 == a2) then
        return false
    end
    local dx = a1.x - a2.x
    local dy = a1.y - a2.y
    if math.abs(dx) < (a1.picture:getWidth()/2 + a2.picture:getWidth()/2) then
        if math.abs(dy) < (a1.picture:getWidth()/2 + a2.picture:getWidth()/2) then
            return true
        end
    end
    return false
end



function CreateShoot(pType, pNamePic, pX, pY, pSpeedX, pSpeedY)
    local shoot = CreateSprite(pNamePic, pX, pY)
    shoot.type = pType
    shoot.posX = pSpeedX
    shoot.posY = pSpeedY
    table.insert(list_shoots, shoot)
    soundShoot:play()
end



function CreateEnemy(pType, pX, pY)

    local picName = ""

    if pType == 1 then
        picName = "alien_1"
    elseif pType == 2 then
        picName = "alien_2"
    elseif pType == 3 then
        picName = "alien_3"
    elseif pType == 4 then
        picName = "turret"
    end

    local enemy = CreateSprite(picName, pX, pY)

    enemy.type = pType

    enemy.asleep = true
    enemy.chronoShoot = 0

    if pType == 1 then
        enemy.vx = 0
        enemy.vy = 2
        enemy.energy = 2
        enemy.point = 1

    elseif pType == 2 then
        local direction = math.random(1, 2)
        if direction == 1 then
            enemy.vx = 1
        else
            enemy.vx = -1
        end
        enemy.vy = 2
        enemy.energy = 1
        enemy.point = 2

    elseif pType == 3 then  -- boss
        enemy.vx = 0
        enemy.vy = camera.speed * 2
        enemy.energy = 20
        enemy.angle = 0
        enemy.point = 10

    elseif pType == 4 then
        enemy.vx = 0
        enemy.vy = camera.speed
        enemy.energy = 4
        enemy.point = 3
    end

    table.insert(list_enemy, enemy)
end



function CreateSprite(pNamePic, pX, pY)
    sprite = {}
    sprite.name = pNamePic
    sprite.x = pX
    sprite.y = pY
    sprite.delete = false
    sprite.picture = love.graphics.newImage("images/"..pNamePic..".png")
    sprite.width = sprite.picture:getWidth()
    sprite.height = sprite.picture:getHeight()
    
    sprite.frame = 1
    sprite.list_frames = {}
    sprite.maxFrame = 1

    table.insert(list_sprites, sprite)

    return sprite
end



function CreateExplode(pX, pY)
    local newExplode = CreateSprite("explode_1", pX, pY)
    newExplode.list_frames = explodeSprites
    newExplode.maxFrame = 5
end



function love.load()
    love.window.setTitle("Shoot 'em up")
    love.window.setMode(1024, 768)

    WIDTH_SCREEN = love.graphics.getWidth()
    HEIGHT_SCREEN = love.graphics.getHeight()

    WIDTH_MAP = 16
    HEIGHT_MAP = #level
    
    StartGame()
end





function ResetGame()
    display_screen = "game"
    for iDelSprites = #list_sprites, 1, -1 do
        table.remove(list_sprites, iDelSprites)
    end
    for iDelEnemy = #list_enemy, 1, -1 do
        table.remove(list_enemy, iDelEnemy)
    end
    for iDelShoot = #list_shoots, 1, -1 do
        table.remove(list_shoots, iDelShoot)
    end
    
    StartGame()
end

function StartGame()
    spaceship = CreateSprite("spaceship", WIDTH_SCREEN/2, HEIGHT_SCREEN/2)
    spaceship.x = WIDTH_SCREEN/2
    spaceship.y = HEIGHT_SCREEN - (spaceship.height*2)

    camera.y = 0
    game.energySpaceship = 100
    
    -- création d'enemy
    local line = 4
    local column = 7
    CreateEnemy(1, (64/2)+(64*(column-1)), -(64/2)-(64*(line-1)))   -- vaisseau 1
    line = 10
    column = 2
    CreateEnemy(2, (64/2)+(64*(column-1)), -(64/2)-(64*(line-1)))   -- vaisseau 2
    line = 7
    column = 14
    CreateEnemy(2, (64/2)+(64*(column-1)), -(64/2)-(64*(line-1)))   -- vaisseau 2
    line = 7
    column = 2
    CreateEnemy(2, (64/2)+(64*(column-1)), -(64/2)-(64*(line-1)))   -- vaisseau 2
    line = 5
    column = 11
    CreateEnemy(4, (64/2)+(64*(column-1)), -(64/2)-(64*(line-1)))   -- tourelle
    line = 16
    column = 8
    CreateEnemy(4, (64/2)+(64*(column-1)), -(64/2)-(64*(line-1)))   -- tourelle
    line = 18
    column = 13
    CreateEnemy(1, (64/2)+(64*(column-1)), -(64/2)-(64*(line-1)))   -- vaisseau 1
    line = 18
    column = 4
    CreateEnemy(2, (64/2)+(64*(column-1)), -(64/2)-(64*(line-1)))   -- vaisseau 2
    line = 21
    column = 14
    CreateEnemy(1, (64/2)+(64*(column-1)), -(64/2)-(64*(line-1)))   -- vaisseau 2
    line = 23
    column = 7
    CreateEnemy(1, (64/2)+(64*(column-1)), -(64/2)-(64*(line-1)))   -- vaisseau 2
    line = 23
    column = 2
    CreateEnemy(1, (64/2)+(64*(column-1)), -(64/2)-(64*(line-1)))   -- vaisseau 1
    line = 25
    column = 2
    CreateEnemy(2, (64/2)+(64*(column-1)), -(64/2)-(64*(line-1)))   -- vaisseau 2
    line = 26
    column = 14
    CreateEnemy(2, (64/2)+(64*(column-1)), -(64/2)-(64*(line-1)))   -- vaisseau 2
    line = 29
    column = 5
    CreateEnemy(2, (64/2)+(64*(column-1)), -(64/2)-(64*(line-1)))   -- vaisseau 2
    line = 29
    column = 7
    CreateEnemy(4, (64/2)+(64*(column-1)), -(64/2)-(64*(line-1)))   -- tourelle
    line = 29
    column = 9
    CreateEnemy(4, (64/2)+(64*(column-1)), -(64/2)-(64*(line-1)))   -- tourelle
    line = 33
    column = 4
    CreateEnemy(1, (64/2)+(64*(column-1)), -(64/2)-(64*(line-1)))   -- vaisseau 1
    line = 35
    column = 6
    CreateEnemy(2, (64/2)+(64*(column-1)), -(64/2)-(64*(line-1)))   -- vaisseau 2
    line = 37
    column = 8
    CreateEnemy(1, (64/2)+(64*(column-1)), -(64/2)-(64*(line-1)))   -- vaisseau 2
    line = 38
    column = 6
    CreateEnemy(1, (64/2)+(64*(column-1)), -(64/2)-(64*(line-1)))   -- vaisseau 2
    line = 38
    column = 11
    CreateEnemy(4, (64/2)+(64*(column-1)), -(64/2)-(64*(line-1)))   -- tourelle
    line = 40
    column = 4
    CreateEnemy(2, (64/2)+(64*(column-1)), -(64/2)-(64*(line-1)))   -- vaisseau 2
    line = 40
    column = 4
    CreateEnemy(2, (64/2)+(64*(column-1)), -(64/2)-(64*(line-1)))   -- vaisseau 2

    line = #level
    column = 9
    CreateEnemy(3, (64/2)+(64*(column-1)), -(64/2)-(64*(line-1)))   -- boss
end

function UpdateGame()
    camera.y = camera.y + camera.speed

    local indexList

    ---------------{LASERS}---------------
    for indexList = #list_shoots, 1, -1 do
        local shoot = list_shoots[indexList]
        shoot.x = shoot.x + shoot.posX
        shoot.y = shoot.y + shoot.posY

        ---------------{COLLISION ENEMI -→ SPACESHIP}---------------
        if shoot.type == "enemy" then
            if collide(spaceship, shoot) then
                CreateExplode(shoot.x, shoot.y)
                shoot.delete = true
                table.remove(list_shoots, indexList)
                if game.energySpaceship == 1 then
                    display_screen = "gameover"
                else
                    game.energySpaceship = game.energySpaceship - 1
                end
            end
        end

        ---------------{COLLISION SPACESHIP -→ ENEMI}---------------
        if shoot.type == "spaceship" then
            local iEnemy
            for iEnemy = #list_enemy, 1, -1 do
                local enemy = list_enemy[iEnemy]    -- récupère l'enemi indexé dans la liste
                if enemy.asleep == false then
                    if collide(shoot, enemy) then
                        CreateExplode(shoot.x, shoot.y)
                        shoot.delete = true
                        table.remove(list_shoots, indexList)
    
                        enemy.energy = enemy.energy - 1
                        if enemy.energy == 0 then

                            game.nbEnemyKill = game.nbEnemyKill + 1
                            game.totalPoint = game.totalPoint + enemy.point

                            local nExplode
                            for nExplode = 1, 5 do
                                CreateExplode(enemy.x + math.random(-10, 10), enemy.y + math.random(-10, 10))
                            end
                            if enemy.type == 3 then
                                win = true
                                timerWin = 50
                                for nExplode = 1, 100 do
                                    CreateExplode(enemy.x + math.random(-150, 150), enemy.y + math.random(-150, 150))
                                end
                            end
                            explodeSound:play()
                            enemy.delete = true
                            table.remove(list_enemy, iEnemy)
                        end
                    end
                end
            end
        end

        ---------------{SUPPRIMER LES TIRS S'IL SONT SORTIS DE L'ÉCRAN}---------------
        if ((shoot.y < 0) or (shoot.y > HEIGHT_SCREEN)) and (shoot.delete == false) then
            shoot.delete = true
            table.remove(list_shoots, indexList)
        end
    end

    ---------------{SUPPRESSION DES SPRITES 'SHOOT'}---------------
    for indexList = #list_sprites, 1, -1 do
        if list_sprites[indexList].delete == true then
            table.remove(list_sprites, indexList)
        end
    end

    -------------------------{ENEMIS}-------------------------
    for indexList = #list_enemy, 1, -1 do
        local enemy = list_enemy[indexList]    -- récupère l'enemi indexé dans la liste

        if enemy.y >= 0 then
            enemy.asleep = false
        end

        if enemy.asleep == false then
            enemy.x = enemy.x + enemy.vx
            enemy.y = enemy.y + enemy.vy

            if enemy.type == 1 or enemy.type == 2 then
                enemy.chronoShoot = enemy.chronoShoot - 1
                if enemy.chronoShoot <= 0 then
                    enemy.chronoShoot = math.random(60, 100)
                    CreateShoot("enemy", "laser2", enemy.x, enemy.y, 0, 10)
                end
            elseif enemy.type == 3 then
                if enemy.y > HEIGHT_SCREEN/3 then
                    enemy.y = HEIGHT_SCREEN/3
                    if (enemy.y == HEIGHT_SCREEN/3) and (game.bossMoveX == false) then
                        enemy.vx = 2
                    end

                    if enemy.x > (WIDTH_SCREEN - enemy.width/2 - 15) then
                        enemy.x = WIDTH_SCREEN - enemy.width/2 - 15
                        enemy.vx = -2
                        game.bossMoveX = true

                    elseif enemy.x < (0 + enemy.width/2 + 15) then
                        enemy.x = 15 + enemy.width/2
                        enemy.vx = 2
                        game.bossMoveX = true
                        
                    end
                end
                enemy.chronoShoot = enemy.chronoShoot - 1
                if enemy.chronoShoot <= 0 then
                    enemy.chronoShoot = math.random(5, 15)
                    local posX, posY
                    enemy.angle = enemy.angle + 0.5
                    posX = 10 * math.cos(enemy.angle)
                    posY = 10 * math.sin(enemy.angle)
                    CreateShoot("enemy", "laser2", enemy.x, enemy.y, posX, posY)
                end
            elseif enemy.type == 4 then
                enemy.chronoShoot = enemy.chronoShoot - 1
                if enemy.chronoShoot <= 0 then
                    enemy.chronoShoot = math.random(15, 50)
                    local posX, posY
                    local angle
                    angle = math.angle(enemy.x, enemy.y, spaceship.x, spaceship.y)
                    posX = 10 * math.cos(angle)
                    posY = 10 * math.sin(angle)
                    CreateShoot("enemy", "laser2", enemy.x, enemy.y, posX, posY)
                end
            end
        else
            enemy.y = enemy.y + camera.speed
        end

        ---------------{VÉRIFIE SI LES ENEMIS NE SONT PAS SORTIS DE L'ÉCRAN}---------------
        if enemy.y > (HEIGHT_SCREEN + (64/2)) then
            enemy.delete = true
            table.remove(list_enemy, indexList)
        end
    end

    ---------------{TRAITEMENT ET SUPPRESSION DES SPRITES}---------------
    for n = #list_sprites, 1, -1 do
        local sprite = list_sprites[n]

        -- sprite animé ?
        if sprite.maxFrame > 1 then
            sprite.frame = sprite.frame + 0.2
            if math.floor(sprite.frame) > sprite.maxFrame then
                sprite.delete = true
            else
                sprite.picture = sprite.list_frames[math.floor(sprite.frame)]
            end
        end

        if sprite.delete == true then
            table.remove(list_sprites, n)
        end
    end

    ---------------{CONTROLE DU VAISSEAU}---------------
    if love.keyboard.isDown("z") and (spaceship.y - spaceship.height - 3) > 0 then
        spaceship.y = spaceship.y - 5
    end
    if love.keyboard.isDown("s") and (spaceship.y + spaceship.height + 3) < HEIGHT_SCREEN then
        spaceship.y = spaceship.y + 5
    end
    if love.keyboard.isDown("q") and (spaceship.x - spaceship.width - 3) > 0 then
        spaceship.x = spaceship.x - 5
    end
    if love.keyboard.isDown("d") and (spaceship.x + spaceship.width + 3) < WIDTH_SCREEN then
        spaceship.x = spaceship.x + 5
    end

    ---------------{VICTOIRE ?}---------------
    if win == true then
        timerWin = timerWin - 1
        if timerWin == 0 then
            display_screen = "win"
        end
    end
end

function love.update(dt)
    if display_screen == "game" then
        UpdateGame()
    end
end





function DrawMenu()
    love.graphics.draw(menuPicture, 0, 0)
end

function DrawGame()
    local lines, columns
    local x, y

    x = 0
    y = (0 - 64) + camera.y

    for lines = HEIGHT_MAP, 1, -1 do
        for columns = 1, WIDTH_MAP do
            local texture = level[lines][columns]
            if texture > 0 then
                love.graphics.draw(tilesMap[texture], x, y, 0, 2, 2)
            end
            x = x + 64
        end
        x = 0
        y = y - 64
    end

    local indexList
    for indexList = 1, #list_sprites do
        local sTab = list_sprites[indexList]
        love.graphics.draw(sTab.picture, sTab.x, sTab.y, 0, 2, 2, sTab.width/2, sTab.height/2)
    end

    love.graphics.scale(2)
    love.graphics.print(game.energySpaceship, (spaceship.x/2) + (spaceship.width/1.5), (spaceship.y/2) - (spaceship.height/4))
    love.graphics.scale(1)
end

function DrawGameOver()
    love.graphics.draw(gameOverPicture, 0, 0)
end

function DrawWin()
    love.graphics.draw(gameWinPicture, 0, 0)
end

function love.draw()
    if display_screen == "menu" then
        DrawMenu()
        love.graphics.print("PRESS SPACE TO START", (WIDTH_SCREEN/2)-55, HEIGHT_SCREEN-100)

    elseif display_screen == "game" then
        DrawGame()

    elseif display_screen == "gameover" then
        DrawGameOver()
        love.graphics.print("TOTAL POINTS : "..game.totalPoint, (WIDTH_SCREEN/2)-30, HEIGHT_SCREEN-200)
        love.graphics.print("TOTAL ENEMYS KILL : "..game.nbEnemyKill, (WIDTH_SCREEN/2)-55, HEIGHT_SCREEN-150)
        love.graphics.print("PRESS SPACE TO START", (WIDTH_SCREEN/2)-55, HEIGHT_SCREEN-100)

    elseif display_screen == "win" then
        DrawWin()
        love.graphics.print("TOTAL POINTS : "..game.totalPoint, (WIDTH_SCREEN/2)-40, HEIGHT_SCREEN-200)
        love.graphics.print("TOTAL ENEMYS KILL : "..game.nbEnemyKill, (WIDTH_SCREEN/2)-55, HEIGHT_SCREEN-150)
        love.graphics.print("PRESS SPACE TO START", (WIDTH_SCREEN/2)-55, HEIGHT_SCREEN-100)
    end
end





function love.keypressed(key)
    if display_screen == "game" then
        if key == "space" then
            CreateShoot("spaceship", "laser1", spaceship.x, spaceship.y - (spaceship.height*2)/2, 0, -10)
        end
    elseif display_screen == "menu" then
        display_screen = "game"
        ResetGame()
    elseif display_screen == "gameover" then
        display_screen = "game"
        ResetGame()
    elseif display_screen == "win" then
        display_screen = "game"
        ResetGame()
    end
end