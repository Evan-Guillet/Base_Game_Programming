local hero = {}

hero.images = {}
hero.images[1] = love.graphics.newImage("images/player_1.png")
hero.images[2] = love.graphics.newImage("images/player_2.png")
hero.images[3] = love.graphics.newImage("images/player_3.png")
hero.images[4] = love.graphics.newImage("images/player_4.png")
hero.currentFrame = 1
hero.line = 1
hero.column = 1
hero.keyPressed = false



function hero.Update(pMap, dt)
    hero.currentFrame = hero.currentFrame + 5*dt
    if math.floor(hero.currentFrame) > #hero.images then
        hero.currentFrame = 1
    end

    if love.keyboard.isDown("q","z","d","s") then
        if hero.keyPressed == false then
            
            local old_column = hero.column
            local old_line = hero.line

            if love.keyboard.isDown("z") and hero.line > 1 then
                hero.line = hero.line - 1
            end
            if love.keyboard.isDown("d") and hero.column < pMap.GRID_WIDTH then
                hero.column = hero.column + 1
            end
            if love.keyboard.isDown("s") and hero.line < pMap.GRID_HEIGHT then
                hero.line = hero.line + 1
            end
            if love.keyboard.isDown("q") and hero.column > 1 then
                hero.column = hero.column - 1
            end

            local id = pMap.Grid[hero.line][hero.column]
            if pMap.IsSolid(id) then
                hero.column = old_column
                hero.line = old_line
            else
                pMap.ClearFogCircle(hero.line, hero.column)
            end

            hero.keyPressed = true
        end
    else
        hero.keyPressed = false
    end
end



function hero.Draw(pMap)
    local x = (hero.column-1) * pMap.TILE_WIDTH
    local y = (hero.line-1) * pMap.TILE_HEIGHT
    love.graphics.draw(hero.images[math.floor(hero.currentFrame)], x, y, 0, 2, 2)
end

return hero