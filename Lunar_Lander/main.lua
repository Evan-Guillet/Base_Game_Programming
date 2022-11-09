local Lander = {}
Lander.x = 0
Lander.y = 0
Lander.angle = -90
Lander.vx = 0
Lander.vy = 0
Lander.speed = 3
Lander.engineOn = false
Lander.ship = love.graphics.newImage("images/ship.png")
Lander.engine = love.graphics.newImage("images/engine.png")

function love.load()
  WIDTH_SCREEN = love.graphics.getWidth()
  HEIGHT_SCREEN = love.graphics.getHeight()

  Lander.x = WIDTH_SCREEN/2
  Lander.y = HEIGHT_SCREEN/2
end

function love.update(dt)
  if love.keyboard.isDown("d") then
    Lander.angle = Lander.angle + 90 * dt
  end
  if love.keyboard.isDown("q") then
    Lander.angle = Lander.angle - 90 * dt
  end
  if love.keyboard.isDown("z") then
    Lander.engineOn = true
    local angle_radian = math.rad(Lander.angle)
    -- convertie l'angle en radian

    local force_x = math.cos(angle_radian) * (Lander.speed * dt)
    -- angle_radian = π/3 ;
    -- [cos(π/3) = 1/2] [sin(π/3) = √3/2] ;
    -- [1/2 = 0.5] [√3/2 = 0.8] ;
    -- [x += 0.5] [y += 0.8] ;
    -- résultat = se déplace moins vite à l'HORIZONTALE [x += 0.5] qu'à la VERTICALE [y += 0.8]

    local force_y = math.sin(angle_radian) * (Lander.speed * dt)
    -- angle_radian = π/6 ;
    -- [cos(π/6) = √3/2] et [sin(π/3) = 1/2] ;
    -- [√3/2 = 0.8] et [1/2 = 0.5] ;
    -- [x += 0.8] et [y += 0.5] ;
    -- résultat = se déplace plus vite à l'HORIZONTALE [x += 0.8] qu'à la VERTICALE [y += 0.5]

    Lander.vx = Lander.vx + force_x
    Lander.vy = Lander.vy + force_y
  else
    Lander.engineOn = false
  end
  
  Lander.vy = Lander.vy + (0.6 * dt)

  if math.abs(Lander.vx) > 2 then
    if Lander.vx > 0 then
      Lander.vx = 2
    else
      Lander.vx = -2
    end
  end
  if math.abs(Lander.vy) > 2 then
    if Lander.vy > 0 then
      Lander.vy = 2
    else
      Lander.vy = -2
    end
  end

  Lander.x = Lander.x + Lander.vx
  Lander.y = Lander.y + Lander.vy
end

function love.draw()
  love.graphics.draw(Lander.ship, Lander.x, Lander.y, math.rad(Lander.angle), 1, 1, Lander.ship:getWidth()/2, Lander.ship:getHeight()/2)
  if Lander.engineOn == true then
    love.graphics.draw(Lander.engine, Lander.x, Lander.y, math.rad(Lander.angle), 1, 1, Lander.engine:getWidth()/2, Lander.engine:getHeight()/2)
  end

  local interface = ""
  interface = interface.."vx: "..tostring(Lander.vx)
  interface = interface.."\nvy: "..tostring(Lander.vy)
  love.graphics.print(interface)
end