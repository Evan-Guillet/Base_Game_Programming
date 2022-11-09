local Game = {}

Game.Map = {}
Game.Map.Grid = {
                {10, 10, 10, 10, 10, 10, 10, 10, 10, 61, 10, 13, 10, 10, 10, 10, 10, 10, 13, 14, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15},
                {10, 10, 10, 10, 10, 11, 11, 11, 10, 10, 10, 13, 10, 10, 10, 10, 10, 10, 10, 14, 15, 15, 129, 15, 15, 15, 15, 15, 15, 68, 15, 15},
                {10, 10, 61, 10, 11, 19, 19, 19, 11, 10, 10, 13, 10, 10, 169, 10, 10, 10, 10, 13, 14, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15},
                {10, 10, 10, 11, 19, 19, 19, 19, 19, 11, 10, 13, 10, 10, 10, 10, 10, 10, 10, 10, 13, 14, 15, 15, 15, 68, 15, 15, 15, 15, 15, 15},
                {10, 10, 10, 11, 19, 19, 19, 19, 19, 11, 10, 13, 10, 10, 10, 10, 10, 10, 61, 10, 10, 14, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15},
                {10, 10, 61, 10, 11, 19, 19, 19, 11, 10, 10, 13, 10, 10, 10, 10, 10, 10, 10, 10, 10, 14, 15, 15, 129, 15, 15, 15, 68, 15, 129, 15},
                {10, 10, 10, 10, 10, 11, 11, 11, 10, 10, 61, 13, 10, 10, 10, 10, 10, 10, 10, 10, 10, 14, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15},
                {10, 10, 10, 10, 10, 13, 13, 13, 13, 13, 13, 13, 10, 10, 10, 10, 10, 169, 10, 10, 10, 13, 14, 15, 15, 15, 15, 15, 15, 15, 15, 15},
                {10, 10, 10, 10, 10, 10, 10, 10, 13, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 61, 10, 13, 14, 14, 14, 14, 14, 14, 14, 15, 129},
                {10, 10, 10, 10, 10, 10, 10, 10, 13, 55, 10, 58, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 13, 14, 14},
                {10, 10, 10, 10, 10, 10, 10, 10, 13, 10, 10, 10, 55, 10, 58, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10},
                {10, 10, 10, 10, 10, 10, 10, 10, 13, 10, 58, 10, 10, 10, 10, 10, 10, 169, 10, 10, 10, 10, 10, 10, 61, 10, 10, 10, 10, 10, 1, 1},
                {10, 10, 10, 10, 10, 10, 10, 10, 13, 10, 10, 10, 58, 10, 10, 10, 10, 10, 10, 10, 10, 61, 10, 10, 10, 10, 10, 10, 10, 1, 37, 37},
                {13, 13, 13, 13, 13, 13, 13, 13, 13, 10, 55, 10, 10, 10, 55, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 1, 1, 37, 37, 37},
                {10, 10, 10, 10, 13, 10, 10, 10, 10, 10, 10, 10, 55, 10, 10, 10, 10, 169, 10, 10, 10, 10, 10, 10, 10, 10, 1, 37, 37, 37, 37, 37},
                {10, 10, 10, 10, 13, 10, 10, 10, 10, 142, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 1, 37, 37, 37, 37, 37, 37},
                {10, 10, 10, 10, 13, 10, 10, 10, 10, 10, 10, 10, 10, 142, 10, 10, 10, 10, 10, 10, 10, 169, 10, 10, 1, 37, 37, 37, 37, 37, 37, 37},
                {14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 1, 37, 37, 37, 37, 37, 37, 37},
                {14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 1, 37, 37, 37, 37, 37, 37, 37},
                {19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 1, 37, 37, 37, 37, 37, 37, 37},
                {20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 1, 37, 37, 37, 37, 37, 37},
                {21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 1, 37, 37, 37, 37},
                {21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 1, 37, 37, 37},
            }

Game.Map.FogGrid = {}

Game.Map.GRID_WIDTH = 32
Game.Map.GRID_HEIGHT = 23
Game.Map.TILE_WIDTH = 32
Game.Map.TILE_HEIGHT = 32

Game.TilesSheet = {}
Game.TilesTextures = {}
Game.TileTypes = {}

Game.Hero = require("hero")



function Game.Load()
    ------------------------- [CHARGEMENT DES TEXTURES] -------------------------
    Game.TilesSheet = love.graphics.newImage("images/tilesheet.png")
    local tileSheetWidth = Game.TilesSheet:getWidth()/Game.Map.TILE_WIDTH
    local tileSheetHeight = Game.TilesSheet:getHeight()/Game.Map.TILE_HEIGHT
    local idTile = 1
    
    Game.TilesTextures[0] = nil

    posTileY = 0
    for lines = 1, tileSheetHeight do
        for columns = 1, tileSheetWidth do
            Game.TilesTextures[idTile] = love.graphics.newQuad(
                (columns-1)*Game.Map.TILE_WIDTH, -- position x dans la tile sheet
                (lines-1)*Game.Map.TILE_HEIGHT,  -- position y dans la tile sheet
                Game.Map.TILE_WIDTH, -- largeur de cette fraction de l'image
                Game.Map.TILE_HEIGHT,    -- hauteur de cette fraction de l'image
                Game.TilesSheet:getWidth(),  -- largeur de la tile sheet
                Game.TilesSheet:getHeight()  -- hauteur de la tile sheet
            )
            idTile = idTile + 1
        end
    end

    Game.TileTypes[1] = "Gravel"
    Game.TileTypes[10] = "Grass"
    Game.TileTypes[11] = "Grass"
    Game.TileTypes[13] = "Sand"
    Game.TileTypes[14] = "Sand"
    Game.TileTypes[15] = "Sand"
    Game.TileTypes[19] = "Water"
    Game.TileTypes[20] = "Water"
    Game.TileTypes[21] = "Sea"
    Game.TileTypes[37] = "Lava"
    Game.TileTypes[55] = "Tree"
    Game.TileTypes[58] = "Tree"
    Game.TileTypes[61] = "Tree"
    Game.TileTypes[68] = "Tree"
    Game.TileTypes[142] = "Tree"
    Game.TileTypes[129] = "Rock"
    Game.TileTypes[169] = "Rock"

    ------------------------- [BROUILLARD DE GUERRE] -------------------------
    Game.Map.FogGrid = {}

    local lines, columns
    for lines = 1, Game.Map.GRID_HEIGHT do
        Game.Map.FogGrid[lines] = {}
        for columns = 1, Game.Map.GRID_WIDTH do
            Game.Map.FogGrid[lines][columns] = 1
        end
    end

    Game.Map.ClearFogCircle(Game.Hero.line, Game.Hero.column)
end



function Game.Map.IsSolid(pID)
    local typeTile = Game.TileTypes[pID]

    if typeTile == "Sea" or
       typeTile == "Tree" or
       typeTile == "Rock" then
       return true
    end
    return false
end



function Game.Update(dt)
    Game.Hero.Update(Game.Map, dt)
end



function Game.Map.ClearFog(pLine, pCol)
    local lines, columns
    for lines = (pLine - 2), pLine + 2 do
        for columns = (pCol - 2), pCol + 2 do
            if (columns > 0) and (columns <= Game.Map.GRID_WIDTH) and (lines > 0) and (lines <= Game.Map.GRID_HEIGHT) then
                Game.Map.FogGrid[lines][columns] = 0
            end
        end
    end
end
function Game.Map.ClearFogCircle(pLine, pCol)
    local lines, columns
    for lines = 1, Game.Map.GRID_HEIGHT do
        for columns = 1, Game.Map.GRID_WIDTH do
            if (columns > 0) and (columns <= Game.Map.GRID_WIDTH) and (lines > 0) and (lines <= Game.Map.GRID_HEIGHT) then
                local dist = math.dist(columns, lines, pCol, pLine)
                if dist < 5 then
                    local alpha = dist/5
                    if Game.Map.FogGrid[lines][columns] > alpha then
                        Game.Map.FogGrid[lines][columns] = alpha
                    end
                end
            end
        end
    end
end



function Game.Draw()
    ------------------------- [AFFICHER LA GRILLE] -------------------------
    local lines, columns
    for lines = 1, Game.Map.GRID_HEIGHT do
        for columns = 1, Game.Map.GRID_WIDTH do
            local id = Game.Map.Grid[lines][columns]  -- id de la texture à afficher
            local textures = Game.TilesTextures[id]  -- stockage de la texture
            if textures ~= nil then
                local x = (columns - 1)*Game.Map.TILE_WIDTH
                local y = (lines - 1)*Game.Map.TILE_HEIGHT
                love.graphics.draw(Game.TilesSheet, textures, x, y)

                ------------------------- [BROUILLARD DE GUERRE] -------------------------
                if Game.Map.FogGrid[lines][columns] > 0 then
                    love.graphics.setColor(0, 0, 0, Game.Map.FogGrid[lines][columns])
                    love.graphics.rectangle("fill", x, y, Game.Map.TILE_WIDTH, Game.Map.TILE_HEIGHT)
                    love.graphics.setColor(255, 255, 255)
                end
            end
        end
    end

    Game.Hero.Draw(Game.Map)

    ------------------------- [AFFICHER L'ID] -------------------------
    local mouse_x = love.mouse.getX()
    local mouse_y = love.mouse.getY()
    local columns = math.floor(mouse_x/Game.Map.TILE_WIDTH) + 1
    local lines = math.floor(mouse_y/Game.Map.TILE_HEIGHT) + 1

    if (columns >= 0) and (columns <= Game.Map.GRID_WIDTH) and (lines >= 0) and (lines <= Game.Map.GRID_HEIGHT) then
        local id = Game.Map.Grid[lines][columns]  -- id de la texture à afficher
        love.graphics.print("Ligne: "..tostring(lines).." Colonne: "..tostring(columns).." ID: "..tostring(id).." ("..tostring(Game.TileTypes[id])..")", 1, Game.Map.TILE_HEIGHT*23)
    else
        love.graphics.print("Hors de la grille !", 1, Game.Map.TILE_HEIGHT*23)
    end
end

return Game