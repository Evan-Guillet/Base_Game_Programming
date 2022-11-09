local sndJump = love.audio.newSource("sons/sfx_movement_jump13.wav", "static")
local musicCool = love.audio.newSource("sons/cool.mp3", "stream")

musicCool:setLooping(true)
musicCool:play()

function love.keypressed(key)
    if key == "z" then
        musicCool:play()
    end
    if key == "s" then
        musicCool:pause()
    end
end