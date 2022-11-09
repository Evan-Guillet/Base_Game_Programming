love.graphics.setDefaultFilter("nearest")

hero = {}
hero.chronoFrame = 1
hero.image = nil
hero.frames = {}
hero.x = 10
hero.y = 15

function love.load()
  hero.image = love.graphics.newImage("herosheet.png")
  hero.frames[1] = love.graphics.newQuad(0,0,24,24, hero.image:getWidth(), hero.image:getHeight())
  hero.frames[2] = love.graphics.newQuad(24,0,24,24, hero.image:getWidth(), hero.image:getHeight())
end

function love.update(dt)
  hero.chronoFrame = hero.chronoFrame + 2*dt
  if hero.chronoFrame >= #hero.frames + 1 then
    hero.chronoFrame = 1
  end
end

function love.draw()
  love.graphics.scale(4,4)

  local frameArrondie = math.floor(hero.chronoFrame)
  love.graphics.draw(hero.image, hero.frames[frameArrondie], hero.x, hero.y)

  love.graphics.print("Frame = "..frameArrondie.." -> "..hero.chronoFrame, 0, 0)
end