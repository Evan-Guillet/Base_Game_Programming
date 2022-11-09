-- bloque le filtrage des images quand elles sont redimensionné
love.graphics.setDefaultFilter("nearest")

math.randomseed(love.timer.getTime())

space_ship = {} -- tableau

-- listes d'éléments
list_sprites = {}
list_shoots = {}
list_aliens = {}

soundShoot = love.audio.newSource("sons/shoot.wav", "static")



---------------{LEVEL 16x12}---------------
level = {}
level = {
            {0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0},
            {0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0},
            {0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0},
            {0,2,2,2,2,0,0,0,0,0,0,0,0,0,0,0},
            {0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0},
            {0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0},
            {0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0},
            {0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0},
            {0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0},
            {0,0,0,0,0,0,2,2,2,2,2,2,2,2,0,0},
            {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
            {3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3},
            {3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3},
            {3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3},
            {3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3},
            {4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4},
        }



---------------{CAMÉRA}---------------
camera = {}
camera.y = 0



---------------{TILES}---------------
tilesMap = {}
local indexMap
for indexMap = 1, 4 do
    tilesMap[indexMap] = love.graphics.newImage("images/tile_"..indexMap..".png")
end



function CreateAlien(pType, pX, pY)

    local pictName = ""

    if pType == 1 then
        pictName = "enemy1"
    elseif pType == 2 then
        pictName = "enemy2"
    elseif pType == 3 then
        pictName = "enemy3"
    end

    local alien = CreateSprite(pictName, pX, pY)

    if pType == 1 then
        alien.vx = 0
        alien.vy = 2

    elseif pType == 2 then
        local direction = math.random(1, 2)
        if direction == 1 then
            alien.vx = 1
        else
            alien.vx = -1
        end
        alien.vy = 2

    elseif pType == 3 then
        local direction = math.random(1, 2)
        if direction == 1 then
            alien.vx = 1
        else
            alien.vx = -1
        end
        alien.vy = 2
    end

    table.insert(list_aliens, alien)
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
    HEIGHT_MAP = 16
    
    StartGame()
end



function StartGame()
    space_ship = CreateSprite("Space_Ship", WIDTH_SCREEN/2, HEIGHT_SCREEN/2)
    space_ship.x = WIDTH_SCREEN/2
    space_ship.y = HEIGHT_SCREEN - (space_ship.height*2)
    
    CreateAlien(1, WIDTH_SCREEN/2, 100)
    CreateAlien(2, WIDTH_SCREEN/4, 100)
    CreateAlien(3, WIDTH_SCREEN*0.75, 100)
end



function love.update(dt)

    camera.y = camera.y + 1

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

    -------------------------{ALIENS}-------------------------
    for indexList = #list_aliens, 1, -1 do
        local alien = list_aliens[indexList]

        alien.x = alien.x + alien.vx
        alien.y = alien.y + alien.vy

        ---------------{VÉRIFIE SI LES ALIENS NE SONT PAS SORTIS DE L'ÉCRAN}---------------
        if alien.y > HEIGHT_SCREEN then
            alien.delete = true
            table.remove(list_aliens, indexList)
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
    love.graphics.print("Nombre d'alien : "..#list_aliens, 0, 40)
end



function love.keypressed(key)
    if key == "space" then
        local shoot = CreateSprite("laser1", space_ship.x, space_ship.y - space_ship.height)
        shoot.speed = -10
        table.insert(list_shoots, shoot)
        soundShoot:play()
    end
end