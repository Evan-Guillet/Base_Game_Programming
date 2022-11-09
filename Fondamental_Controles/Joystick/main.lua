-- title:   
-- author: game developer
-- desc:   short description
-- script: lua
-- input:  gamepad
-- saveid: MyAwesomeGame


  -- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

hero = {}
hero.image = nil
hero.x = 10
hero.y = 15

-- Quelques globales pour faire joujou
joysticks = love.joystick.getJoysticks()
buttons = {}
xAxis = 0
yAxis = 0

function love.load()
  hero.image = love.graphics.newImage("hero.png")
end

function love.update(dt)
  joysticks = love.joystick.getJoysticks()

  -- Méthode "joystick"
  buttons = {}
  if #joysticks > 0 then
    local joy1 = joysticks[1]
    for b=1,joy1:getButtonCount() do
      buttons[b] = joy1:isDown(b)
    end
  end

  -- Méthode "gamePad"
  local jRight = false
  local jLeft = false
  local jUp = false
  local jDown = false
  local butA = false
  local butB = false
  local butX = false
  local butY = false

  xAxis = 0
  yAxis = 0

  if #joysticks > 0 then
    local joy1 = joysticks[1]
    -- Directions du D-Pad :
    jRight = joy1:isGamepadDown("dpright")
    jLeft = joy1:isGamepadDown("dpleft")
    jUp = joy1:isGamepadDown("dpup")
    jDown = joy1:isGamepadDown("dpdown")
    -- Directions du stick analogique
    xAxis = joy1:getGamepadAxis("leftx")
    yAxis = joy1:getGamepadAxis("lefty")
    -- Les boutons principaux
    butA = joy1:isGamepadDown("a")
    butB = joy1:isGamepadDown("b")
    butX = joy1:isGamepadDown("x")
    butY = joy1:isGamepadDown("y")
  end

  -- Déplacement avec le D-Pad
  if love.keyboard.isDown("right") or jRight then
    hero.x = hero.x + 20*dt
  end
  if love.keyboard.isDown("left") or jLeft then
    hero.x = hero.x - 20*dt
  end
  if love.keyboard.isDown("up") or jUp then
    hero.y = hero.y - 20*dt
  end
  if love.keyboard.isDown("down") or jDown then
    hero.y = hero.y + 20*dt
  end

  -- Déplacement avec le stick analogique
  -- Attention il n'est jamais totalemet à 0
  -- Donc mieux vaut l'arrondir !
  if math.abs(xAxis) > 0.2 then
    hero.x = hero.x + (xAxis*40)*dt
  end
  if math.abs(yAxis) > 0.2 then
    hero.y = hero.y + (yAxis*40)*dt
  end
end

function love.draw()
  love.graphics.scale(2,2)

  love.graphics.draw(hero.image, hero.x, hero.y)

  if #joysticks>0 then
    love.graphics.print(tostring(#joysticks).." joystick(s) détecté(s)... isGamepad="..tostring(joysticks[1]:isGamepad()))
  else
    love.graphics.print("Aucun joystick détecté...")
  end

  -- Ce bout de code affiche l'état des boutons dans l'ordre
  -- sans savoir quelle est leur position sur le joystick
  local xButton = 10
  local yButton = 100
  love.graphics.print("Joystick buttons:", xButton, yButton)
  yButton = yButton + 20
  for b=1,#buttons do
    if buttons[b] == true then
      style = "fill"
    else
      style = "line"
    end
    love.graphics.rectangle(style, xButton, yButton, 20, 20)
    love.graphics.print(tostring(b), xButton + 1, yButton)
    xButton = xButton + 20 + 3
  end

  -- Ce bout de code affiche la valeur des axes du stick du gamePad (si détecté)
  yButton = yButton + 20 + 10
  xButton = 10
  love.graphics.print("Axe X: "..tostring(xAxis), xButton, yButton)
  yButton = yButton + 20
  love.graphics.print("Axe Y: "..tostring(yAxis), xButton, yButton)

end

function love.keypressed(key)
  print("La touche "..key.." vient d'être enfoncée !")

  if key == "escape" then
    love.event.quit()
  end
end