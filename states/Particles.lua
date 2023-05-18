class.Particles()

function Particles:load()
  tremor = 1
end

function Particles:close()
end

function Particles:enable()
  canvas = love.graphics.newCanvas(100, 100)

  love.graphics.setCanvas(canvas)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.circle("fill", 50,50, 50)
  love.graphics.setCanvas()
  canvas:setFilter("linear", "linear")
  
  psystems = {
    
  }
  
  for i = 1, 5 do
    psystems[i] = love.graphics.newParticleSystem(canvas, 84)
    psystems[i]:setDirection(i)
    psystems[i]:setEmissionArea("none", 0, 0, 0, false)
    psystems[i]:setEmissionRate(6)
    psystems[i]:setEmitterLifetime(-1)
    psystems[i]:setInsertMode("top")
    psystems[i]:setLinearAcceleration(0, 0, 0, 0)
    psystems[i]:setLinearDamping(6.6, 8.7)
    psystems[i]:setOffset(50, 50)
    psystems[i]:setParticleLifetime(10, 11 + i)
    --psystems[i]:setRadialAcceleration(0, 0)
    --psystems[i]:setRelativeRotation(false)
    --psystems[i]:setRotation(0, 0)
    psystems[i]:setSizes(0.4)
    psystems[i]:setSizeVariation(0)
    psystems[i]:setSpeed(841, 997)
    psystems[i]:setSpin(0, 0)
    psystems[i]:setSpinVariation(0)
    psystems[i]:setSpread(0.15)
    psystems[i]:setTangentialAcceleration(737, 1400)
  end

  psystems[1]:setColors(1, 1, 1, 1,     0, 0, 0, 0)
  psystems[2]:setColors(.25, 0, 1, 1,   .25, 0, 1, 0)
  psystems[3]:setColors(.5, 0, 1, 1,    .5, 0, 1, 0)
  psystems[4]:setColors(.75, 0, 1, 1,   .75, 0, 1, 0)
  psystems[5]:setColors(1, 0, 1, 1,   1, 0, 1, 0)
end

function Particles:disable()
end

function Particles:update(dt)
  local fifthColour = {
    luna.colours[1], luna.colours[2], luna.colours[3], 1,
    luna.colours[1], luna.colours[2], luna.colours[3], 0
  }
  psystems[1]:setColors(unpack(fifthColour))

  for i = 1, #psystems do
    psystems[i]:update(dt)
  end
end

function Particles:draw()
  love.graphics.setBlendMode("add")
  for i = #psystems, 1, -1 do
    --love.graphics.print("Particle n" .. i .. " - " .. tostring(psystems[i]:isPaused()), 300 + 150 * i, love.graphics.getHeight()/2)
    --love.graphics.draw(psystems[i], 350 + 150 * i, love.graphics.getHeight()/2 - 50)
    love.graphics.draw(psystems[i], love.graphics.getWidth()/2, love.graphics.getHeight()/2)
  end
  love.graphics.setBlendMode("alpha")
end

function Particles:keypressed(key)
end
