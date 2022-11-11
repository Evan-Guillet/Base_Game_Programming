-- bloque le filtrage des images quand elles sont redimensionné
love.graphics.setDefaultFilter("nearest")

math.randomseed(love.timer.getTime())

space_ship = {} -- tableau

-- listes d'éléments
list_sprites = {}
list_shoots = {}
list_enemy = {}

soundShoot = love.audio.newSource("sons/shoot.wav", "static")



---------------{LEVEL 16x12}---------------
level = {}
level = {
            { 0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0 },
            { 0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0 },
            { 0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0 },
            { 0,2,2,2,2,0,0,0,0,0,0,0,0,0,0,0 },
            { 0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0 },
            { 0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0 },
            { 0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0 },
            { 0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0 },
            { 0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0 },
            { 0,0,0,0,0,0,2,2,2,2,2,2,2,2,0,0 },
            { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 },
            { 0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0 },
            { 0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0 },
            { 0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0 },
            { 0,2,2,2,2,0,0,0,0,0,0,0,0,0,0,0 },
            { 0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0 },
            { 0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0 },
            { 0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0 },
            { 0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0 },
            { 0,0,0,0,0,0,2,2,2,2,2,2,2,2,0,0 },
            { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 },
            { 0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0 },
            { 0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0 },
            { 0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0 },
            { 0,2,2,2,2,0,0,0,0,0,0,0,0,0,0,0 },
            { 0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0 },
            { 0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0 },
            { 0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0 },
            { 0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0 },
            { 0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0 },
            { 0,0,0,0,0,0,2,2,2,2,2,2,2,2,0,0 },
            { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 },
            { 0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0 },
            { 0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0 },
            { 0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0 },
            { 0,2,2,2,2,0,0,0,0,0,0,0,0,0,0,0 },
            { 0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0 },
            { 0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0 },
            { 0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0 },
            { 0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0 },
            { 0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0 },
            { 0,0,0,0,0,0,2,2,2,2,2,2,2,2,0,0 },
            { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 },
            { 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3 },
        }



---------------{CAMÉRA}---------------
camera = {}
camera.y = 0
camera.speed = 1



---------------{TILES}---------------
tilesMap = {}
local indexMap
for indexMap = 1, 3 do
    tilesMap[indexMap] = love.graphics.newImage("images/tile_"..indexMap.."(2).png")
end



function CreateEnemy(pType, pX, pY)

    local picName = ""

    if pType == 1 then
        picName = "alien_1(2)"
    elseif pType == 2 then
        picName = "alien_2(2)"
    elseif pType == 3 then
        picName = "alien_3(2)"
    elseif pType == 4 then
        picName = "turret(2)"
    end

    local enemy = CreateSprite(picName, pX, pY)

    enemy.asleep = true

    if pType == 1 then
        enemy.vx = 0
        enemy.vy = 2

    elseif pType == 2 then
        local direction = math.random(1, 2)
        if direction == 1 then
            enemy.vx = 1
        else
            enemy.vx = -1
        end
        enemy.vy = 2

    elseif pType == 3 then
        local direction = math.random(1, 2)
        if direction == 1 then
            enemy.vx = 1
        else
            enemy.vx = -1
        end
        enemy.vy = 2

    elseif pType == 4 then
        enemy.vx = 0
        enemy.vy = camera.speed
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
    
    table.insert(list_sprites, sprite)

    return sprite
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



function StartGame()
    space_ship = CreateSprite("Space_Ship", WIDTH_SCREEN/2, HEIGHT_SCREEN/2)
    space_ship.x = WIDTH_SCREEN/2
    space_ship.y = HEIGHT_SCREEN - (space_ship.height*2)
    
    -- création d'enemy
    local line = 4
    local column = 7
    CreateEnemy(1, (64/2)+(64*(column-1)), -(64/2)-(64*(line-1)))
    line = 10
    column = 2
    CreateEnemy(2, (64/2)+(64*(column-1)), -(64/2)-(64*(line-1)))
    line = 7
    column = 14
    CreateEnemy(2, (64/2)+(64*(column-1)), -(64/2)-(64*(line-1)))
    line = 7
    column = 2
    CreateEnemy(2, (64/2)+(64*(column-1)), -(64/2)-(64*(line-1)))
    line = 12
    column = 2
    CreateEnemy(4, (64/2)+(64*(column-1)), -(64/2)-(64*(line-1)))
end



function love.update(dt)

    camera.y = camera.y + camera.speed

    local indexList

    ---------------{LASERS}---------------
    for indexList = #list_shoots, 1, -1 do
        local shoot = list_shoots[indexList]
        shoot.y = shoot.y + shoot.speed

        ---------------{VÉRIFIE SI LES TIRS NE SONT PAS SORTIS DE L'ÉCRAN}---------------
        if shoot.y < 0 or shoot.y > HEIGHT_SCREEN then
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

    -------------------------{ENEMYS}-------------------------
    for indexList = #list_enemy, 1, -1 do
        local enemy = list_enemy[indexList]    -- récupère l'enemy indexé dans la liste

        if enemy.y >= 0 then
            enemy.asleep = false
        end

        if enemy.asleep == false then
            enemy.x = enemy.x + enemy.vx
            enemy.y = enemy.y + enemy.vy
        else
            enemy.y = enemy.y + camera.speed
        end

        ---------------{VÉRIFIE SI LES ENEMYS NE SONT PAS SORTIS DE L'ÉCRAN}---------------
        if enemy.y > HEIGHT_SCREEN then
            enemy.delete = true
            table.remove(list_enemy, indexList)
        end
    end

    ---------------{CONTROLE DU VAISSEAU}---------------
    if love.keyboard.isDown("z") and space_ship.y > 0 then
        space_ship.y = space_ship.y - 5
    end
    if love.keyboard.isDown("s") and space_ship.y < HEIGHT_SCREEN then
        space_ship.y = space_ship.y + 5
    end
    if love.keyboard.isDown("q") and space_ship.x > 0 then
        space_ship.x = space_ship.x - 5
    end
    if love.keyboard.isDown("d") and space_ship.x < WIDTH_SCREEN then
        space_ship.x = space_ship.x + 5
    end
end



function love.draw()
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

    love.graphics.print("Nombre de tirs : "..#list_shoots, 0, 0)
    love.graphics.print("Nombre de Sprites : "..#list_sprites, 0, 20)
    love.graphics.print("Nombre d'enemy : "..#list_enemy, 0, 40)
end



function love.keypressed(key)
    if key == "space" then
        local shoot = CreateSprite("laser1", space_ship.x, space_ship.y - space_ship.height)
        shoot.speed = -10
        table.insert(list_shoots, shoot)
        soundShoot:play()
    end
end