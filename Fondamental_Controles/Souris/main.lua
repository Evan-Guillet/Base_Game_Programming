-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

hero = {}
hero.image = nil
hero.x = 10
hero.y = 15

function love.load()
  hero.image = love.graphics.newImage("hero.png")
end

function love.update(dt)
  if love.mouse.isDown(1) then
    hero.x = love.mouse.getX()
    hero.y = love.mouse.getY()
  end
end

function love.draw()
  love.graphics.draw(hero.image, hero.x, hero.y)
end

function love.mousepressed(x, y, button)
  print("Le bouton "..tostring(button).." vient d'être enfoncé")
  if button == 2 then
    hero.x = x
    hero.y = y
  end
end

function love.mousereleased(x, y, button)
  print("Le bouton "..tostring(button).." vient d'être relaché")
end

function love.mousemoved(x, y)
  print("La souris s'est déplacée en "..tostring(x)..","..tostring(y))
end

function love.wheelmoved(x, y)
  print("La roulette vient de tourner de (x,y) : "..tostring(x)..","..tostring(y))
end


function love.keypressed(key)
  print("La touche "..key.." vient d'être enfoncée !")

  if key == "escape" then
    love.event.quit()
  end
end