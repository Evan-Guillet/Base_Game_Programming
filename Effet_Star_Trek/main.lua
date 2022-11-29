-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end

local scaleZoom = 20

local Kirk = {}
Kirk.picture = nil
Kirk.x = 0
Kirk.y = 0
Kirk.isBeam = true
Kirk.beamLevel = 0
Kirk.maxPercent = 60

local sndTransporter = love.audio.newSource("son/voyager_transporter.wav", "stream")



function love.load()
    love.window.setTitle("Effet Star Trek")
    love.graphics.setBackgroundColor(101/255,117/255,166/255)
    
    WIDTH_SCREEN = love.graphics.getWidth() / scaleZoom
    HEIGHT_SCREEN = love.graphics.getHeight() / scaleZoom

    Kirk.picture = love.graphics.newImage("images/kirk.png")
    Kirk.x = math.floor(WIDTH_SCREEN/2) - Kirk.picture:getWidth() / 2
    Kirk.y = math.floor(HEIGHT_SCREEN/2) - Kirk.picture:getHeight() / 2

    sndTransporter:play()
end

 

function love.update(dt)
    if Kirk.isBeam then
        local coef = 0.4 * 60 * dt
        Kirk.beamLevel = Kirk.beamLevel + coef

        if Kirk.beamLevel >= Kirk.maxPercent then
            Kirk.isBeam = false
            Kirk.beamLevel = 0
        end
    end
end



local mask_shader = love.graphics.newShader[[
   vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
      if (Texel(texture, texture_coords).rgba == vec4(0.0)) {
         // a discarded pixel wont be applied as the stencil.
         discard;
      }
      return vec4(1.0);
   }
]]

local function StencilFunction()
    love.graphics.setShader(mask_shader)
    love.graphics.draw(Kirk.picture, Kirk.x, Kirk.y)
    love.graphics.setShader()
end



function love.draw()
    love.graphics.scale(scaleZoom, scaleZoom)

    if Kirk.isBeam == false then
        love.graphics.draw(Kirk.picture, Kirk.x, Kirk.y)
    else
        -- Kirk en filigramme
        love.graphics.setColor(1, 1, 1, 1*(Kirk.beamLevel/Kirk.maxPercent))
        love.graphics.draw(Kirk.picture, Kirk.x, Kirk.y)

        local percent
        if Kirk.beamLevel <= (Kirk.maxPercent / 2) then
            percent = (Kirk.beamLevel * 2) / 100
        else
            percent = ((Kirk.maxPercent - Kirk.beamLevel) * 2) / 100
        end

        local w, h = Kirk.picture:getWidth(), Kirk.picture:getHeight()
        local nbPoints = (w*h) * percent

        love.graphics.stencil(StencilFunction, "replace", 1)
        love.graphics.setStencilTest("greater", 0)
        love.graphics.setColor(253/255, 251/255, 212/255, 255/255)
        local np
        for np = 1, nbPoints do
            local rx, ry = math.random(0, w-1), math.random(0, h-1)
            love.graphics.rectangle("fill", Kirk.x + rx, Kirk.y + ry, 1, 1)
        end
        love.graphics.setStencilTest()
    end
end



function love.keypressed(key)
  
end
