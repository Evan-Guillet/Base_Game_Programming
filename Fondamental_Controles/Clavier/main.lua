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
  if love.keyboard.isDown("right") then
    hero.x = hero.x + 10*dt
  end
  if love.keyboard.isDown("left") then
    hero.x = hero.x - 10*dt
  end
  if love.keyboard.isDown("up") then
    hero.y = hero.y - 10*dt
  end
  if love.keyboard.isDown("down") then
    hero.y = hero.y + 10*dt
  end
end

function love.draw()
  love.graphics.scale(4,4)

  love.graphics.draw(hero.image, hero.x, hero.y)
end

function love.keypressed(key)
  print("La touche "..key.." vient d'être enfoncée !")

  if key == "escape" then
    love.event.quit()
  end
end