--Author :
--+-+-+-+-+-+-+-+-+-+
--|I|A|m|T|e|r|r|o|r|
--+-+-+-+-+-+-+-+-+-+

-- Inspired by : https://www.gamecodeur.fr --- https://www.gamecodeur.fr/liste-ateliers/atelier-lunar-lander-love2d/


-- DEBUG --------------------------------------------------------------------------------------------------------------

-- This line is used to display traces in the console during the execution
io.stdout:setvbuf('no')

-- This line is used to debug step by step in ZeroBrane Studio
if arg[#arg] == "-debug" then require("mobdebug").start() end


-- VARIABLES ----------------------------------------------------------------------------------------------------------

local lander = {}
lander.x = 0
lander.y = 0
lander.angle = 270
lander.vx = 0
lander.vy = 0
lander.speed = 3
lander.engineOne = false
lander.img = love.graphics.newImage("images/ship.png")
lander.imgEngine = love.graphics.newImage("images/engine.png")


-- FUNCTIONS ----------------------------------------------------------------------------------------------------------

function rebound()
  if lander.y <= 0 then
    lander.vy = lander.vy * - 1
  end
  if lander.y >= hauteur then
    lander.vy = lander.vy * - 1
  end
  if lander.x <= 0 then
    lander.vx = lander.vx * - 1
  end
  if lander.x >= largeur then
    lander.vx = lander.vx * - 1
  end
end

-- LÖVE ---------------------------------------------------------------------------------------------------------------

function love.load()
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()

  lander.x = largeur / 2
  lander.y = hauteur / 2

end

function love.update(dt)    
  if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
    lander.angle = lander.angle + (90 * dt)
    if lander.angle > 360 then lander.angle = 0 end
  end
  if love.keyboard.isDown("left") or love.keyboard.isDown("q") then
    lander.angle = lander.angle - (90 * dt)
    if lander.angle < 0 then lander.angle = 360 end
  end
  if love.keyboard.isDown("up") or love.keyboard.isDown("z") then
    lander.engineOn = true
    
    local angle_radian = math.rad(lander.angle)
    local force_x = math.cos(angle_radian) * (lander.speed * dt)
    local force_y = math.sin(angle_radian) * (lander.speed * dt)
    if math.abs(force_x) < 0.001 then force_x = 0 end
    if math.abs(force_y) < 0.001 then force_y = 0 end
    lander.vx = lander.vx + force_x
    lander.vy = lander.vy + force_y
  else
    lander.engineOn = false
  end
    
  lander.vy = lander.vy + (0.6 * dt)

  if math.abs(lander.vx) > 2 then
    if lander.vx > 0 then
      lander.vx = 2
    else
      lander.vx = -2
    end
  end
  if math.abs(lander.vy) > 2 then
    if lander.vy > 0 then
      lander.vy = 2
    else
      lander.vy = -2
    end
  end

  lander.x = lander.x + lander.vx
  lander.y = lander.y + lander.vy
  
  rebound()
end

function love.draw()
  love.graphics.draw(lander.img, lander.x, lander.y, math.rad(lander.angle), 1, 1, lander.img:getWidth()/2, lander.img:getHeight()/2)

  if lander.engineOn == true then
    love.graphics.draw(lander.imgEngine, lander.x, lander.y, math.rad(lander.angle), 1, 1, lander.imgEngine:getWidth()/2, lander.imgEngine:getHeight()/2)
  end

  local sDebug ="Debug:"
  sDebug = sDebug.."angle="..tostring(lander.angle)
  sDebug = sDebug.."vx ="..tostring(lander.vx)
  sDebug = sDebug.."vy ="..tostring(lander.vy)
  love.graphics.print(sDebug,0,0)

end