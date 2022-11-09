leftPad = {}
leftPad.x = 0
leftPad.y = 0
leftPad.largeur = 20
leftPad.hauteur = 80

rightPad = {}
rightPad.x = 0
rightPad.y = 0
rightPad.largeur = 20
rightPad.hauteur = 80

balle = {}
balle.x = 0
balle.y = 0
balle.largeur = 15
balle.hauteur = 15
balle.vitesse_x = 4
balle.vitesse_y = 4

player1 = {}
player1.points = 0

player2 = {}
player2.points = 0

listeTrailBalle = {}
listeTrailLeftPad = {}
listeTrailRightPad = {}



function love.load()
  WIDTH_SCREEN = love.graphics.getWidth()  -- stocker la largeur d'écran
  HEIGHT_SCREEN = love.graphics.getHeight()  -- stocker la hauteur d'écran

  ----- [POSITION INITIALE DU PAD GAUCHE] -----
  leftPad.x = 0
  leftPad.y = (HEIGHT_SCREEN/2) - (leftPad.hauteur/2)
  ---------------------------------------------

  ----- [POSITION INITIALE DU PAD DROITE] -----
  rightPad.x = WIDTH_SCREEN - rightPad.largeur
  rightPad.y = (HEIGHT_SCREEN/2) - (rightPad.hauteur/2)
  ---------------------------------------------

  ----- [POSITION INITIALE DE LA BALLE] -----
  balle.x = (WIDTH_SCREEN/2) - (balle.largeur/2)
  balle.y = (HEIGHT_SCREEN/2) - (balle.hauteur/2)
  -------------------------------------------

  loseSound = love.audio.newSource("perdu.wav", "static") -- joue un son quand on perd
  collisionSound = love.audio.newSource("mur.wav", "static")  -- joue un son quand il y a une collision
end



function love.update(dt)
  ---------- [CONTROLE VERTICALE DU PAD GAUCHE] ----------
  if love.keyboard.isDown("s") and leftPad.y < (HEIGHT_SCREEN - leftPad.hauteur) then
    leftPad.y = leftPad.y + 4
  end
  if love.keyboard.isDown("z") and leftPad.y > 0 then
    leftPad.y = leftPad.y - 4
  end
  --------------------------------------------------------

  ---------- [CONTROLE VERTICALE DU PAD DROITE] ----------
  if love.keyboard.isDown("down") and rightPad.y < (HEIGHT_SCREEN - rightPad.hauteur) then
    rightPad.y = rightPad.y + 4
  end
  if love.keyboard.isDown("up") and rightPad.y > 0 then
    rightPad.y = rightPad.y - 4
  end
  --------------------------------------------------------

  ---------- [RÉINITIANLISER LES POINTS DES JOUEURS] ----------
  if love.keyboard.isDown("r") then
    player1.points = 0
    player2.points = 0
    CentreBalle()
    love.audio.play(collisionSound)
  end
  -------------------------------------------------------------

  ---------- [TRAINÉE DE LA BALLE] ----------
  for n = #listeTrailBalle, 1, -1 do
    local tB = listeTrailBalle[n]
    tB.vie = tB.vie - dt
    tB.x = tB.x + tB.vx
    tB.y = tB.y + tB.vy
    if tB.vie <= 0 then
      table.remove(listeTrailBalle, n)
    end
  end

  local trailBalle = {}
  trailBalle.x = balle.x
  trailBalle.y = balle.y
  trailBalle.vx = math.random(-1, 1)
  trailBalle.vy = math.random(-1, 1)
  trailBalle.vie = 0.5
  table.insert(listeTrailBalle, trailBalle)
  -------------------------------------------

  ---------- [TRAINÉE DU PAD GAUCHE] ----------
  for n = #listeTrailLeftPad, 1, -1 do
    local tG = listeTrailLeftPad[n]
    tG.vie = tG.vie - dt
    if tG.vie <= 0 then
      table.remove(listeTrailLeftPad, n)
    end
  end

  local trailLeftPad = {}
  trailLeftPad.x = leftPad.x
  trailLeftPad.y = leftPad.y
  trailLeftPad.vie = 0.3
  table.insert(listeTrailLeftPad, trailLeftPad)
  ---------------------------------------------

  ---------- [TRAINÉE DU PAD DROITE] ----------
  for n = #listeTrailRightPad, 1, -1 do
    local tD = listeTrailRightPad[n]
    tD.vie = tD.vie - dt
    if tD.vie <= 0 then
      table.remove(listeTrailRightPad, n)
    end
  end

  local trailRightPad = {}
  trailRightPad.x = rightPad.x
  trailRightPad.y = rightPad.y
  trailRightPad.vie = 0.3
  table.insert(listeTrailRightPad, trailRightPad)
  ---------------------------------------------

  ---------- [CONTROLE DE LA VITESSE INITIAL DE LA BALLE] ----------
  balle.x = balle.x + balle.vitesse_x
  balle.y = balle.y + balle.vitesse_y
  ------------------------------------------------------------------

  ---------- [COLLISION AVEC LES MURS] ----------
  if balle.x < 0 then --[GAUCHE]
    CentreBalle()
    balle.vitesse_x = balle.vitesse_x + 8
    player2.points = player2.points + 1
    love.audio.play(loseSound)
  end
  if balle.x > (WIDTH_SCREEN - balle.largeur) then --[DROITE]
    CentreBalle()
    balle.vitesse_x = balle.vitesse_x - 8
    player1.points = player1.points + 1
    love.audio.play(loseSound)
  end
  if balle.y < 0 then --[HAUT]
    balle.vitesse_y = balle.vitesse_y + 4
    love.audio.play(collisionSound)
  end
  if balle.y > (HEIGHT_SCREEN - balle.hauteur) then --[BAS]
    balle.vitesse_y = balle.vitesse_y - 4
    love.audio.play(collisionSound)
  end
  -----------------------------------------------

  ---------- [COLLISION AVEC LE PAD GAUCHE] ----------
  if (balle.x <= leftPad.x + leftPad.largeur) and (balle.y + balle.hauteur >= leftPad.y) and (balle.y <= leftPad.y + leftPad.hauteur) then
    balle.x = leftPad.x + leftPad.largeur
    love.audio.play(collisionSound)
    balle.vitesse_x = balle.vitesse_x + 4
  end
  ---------------------------------------------

  ---------- [COLLISION AVEC LE PAD DROITE] ----------
  if (balle.x + balle.largeur >= rightPad.x) and (balle.y + balle.hauteur >= rightPad.y) and (balle.y <= rightPad.y + rightPad.hauteur) then
    balle.x = rightPad.x - balle.largeur
    love.audio.play(collisionSound)
    balle.vitesse_x = balle.vitesse_x - 4
  end
  ----------------------------------------------------
end



function love.draw()
  love.graphics.rectangle("fill", leftPad.x, leftPad.y, leftPad.largeur, leftPad.hauteur) -- affiche le pad de gauche
  love.graphics.rectangle("fill", rightPad.x, rightPad.y, rightPad.largeur, rightPad.hauteur) -- affiche le pad de droite
  love.graphics.setColor(1, 1, 0)
  love.graphics.circle("fill", balle.x, balle.y, balle.largeur, balle.hauteur) -- affiche la balle
  love.graphics.setColor(1, 0, 0)
  love.graphics.line(WIDTH_SCREEN/2, 0, WIDTH_SCREEN/2, HEIGHT_SCREEN)
  love.graphics.setColor(1, 1, 1, 1)

  ------------------------------[TRAINÉE DE LA BALLE]------------------------------
  for n=1, #listeTrailBalle do
    local tB = listeTrailBalle[n]
    love.graphics.setColor(1, 1, 0, tB.vie/8)
    love.graphics.circle("fill", tB.x, tB.y, balle.largeur, balle.hauteur) -- affiche la trainée de la balle
    love.graphics.setColor(1, 1, 1, 1)
  end
  ---------------------------------------------------------------------------------

  ------------------------------[TRAINÉE DU PAD GAUCHE]------------------------------
  for n=1, #listeTrailLeftPad do
    local tG = listeTrailLeftPad[n]
    love.graphics.setColor(1, 1, 1, tG.vie/8)
    love.graphics.rectangle("fill", tG.x, tG.y, leftPad.largeur, leftPad.hauteur) -- affiche la trainée de la balle
    love.graphics.setColor(1, 1, 1, 1)
  end
  -----------------------------------------------------------------------------------

  -----------------------------[TRAINÉE DU PAD DROITE]------------------------------
  for n=1, #listeTrailRightPad do
    local tD = listeTrailRightPad[n]
    love.graphics.setColor(1, 1, 1, tD.vie/8)
    love.graphics.rectangle("fill", tD.x, tD.y, rightPad.largeur, rightPad.hauteur) -- affiche la trainée de la balle
    love.graphics.setColor(1, 1, 1, 1)
  end
  -----------------------------------------------------------------------------------

  local font = love.graphics.newFont(9, "mono")
  font:setFilter("nearest")
  love.graphics.setFont(font)
  love.graphics.scale(4)
	love.graphics.print (player1.points, (WIDTH_SCREEN/9), 5)
  love.graphics.print (player2.points, (WIDTH_SCREEN/7.75) + 1, 5)
end

function CentreBalle()
  balle.x = (WIDTH_SCREEN/2) - (balle.largeur/2)
  balle.y = (HEIGHT_SCREEN/2) - (balle.hauteur/2)
end