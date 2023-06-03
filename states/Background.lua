class.Background()

function Background:load()
  bgCanvas = love.graphics.newCanvas(luna.settings.video.w, luna.settings.video.h)
  recCanvas = love.graphics.newCanvas(luna.settings.video.w, luna.settings.video.h)
  
  --[[ Background ]]
  background = love.graphics.newImage("assets/images/bg.png")

  local seta = love.graphics.newImage("assets/images/arrow.png")
  seta:setFilter("linear", "linear")
  
  bgPs = love.graphics.newParticleSystem(seta, 336)
  bgPs:setColors(0.46, 0.29, 1, 0, 0.07, 0, 1, 1, 0.40, 0, 1, 0.5, 0.45, 0, 1, 0)
  bgPs:setDirection(0)
  bgPs:setEmissionArea("none", 0, 0, 0, false)
  bgPs:setEmissionRate(20)
  bgPs:setEmitterLifetime(-1)
  bgPs:setInsertMode("random")
  bgPs:setLinearAcceleration(-4.13, -2.5, 4.13, 2.5)
  bgPs:setLinearDamping(0, 0)
  bgPs:setOffset(50, 25.5)
  bgPs:setParticleLifetime(1.8, 16)
  bgPs:setRadialAcceleration(0, 0)
  bgPs:setRelativeRotation(true)
  bgPs:setRotation(0, 0)
  bgPs:setSizes(0.05, 0.56)
  bgPs:setSizeVariation(1)
  bgPs:setSpeed(0.51, 81.02)
  bgPs:setSpin(0, 0)
  bgPs:setSpinVariation(0)
  bgPs:setSpread(6.29)
  bgPs:setTangentialAcceleration(0, 0)
end

function Background:close()
end

function Background:enable()
end

function Background:disable()
end

function Background:update(dt)
  bgPs:update(dt)
end

function Background:draw()
  -- Desenha partículas em um fundo sem clear
  love.graphics.setCanvas(bgCanvas)
    love.graphics.setBlendMode("alpha")
      love.graphics.draw(bgPs, luna.settings.video.w/2, luna.settings.video.h/2, luna.colours[1])
  
  -- Já desenha canvas no finalScene
  love.graphics.setCanvas(finalScene)
    love.graphics.setColor(1 - luna.colours[1], 1 - luna.colours[2], 1 - luna.colours[3], 1) -- Cor invertida
      love.graphics.draw(bgCanvas)
    love.graphics.setColor(1, 1, 1, 1)
    
   -- Desesnha imagem de fundo sobre as partículas
  love.graphics.setCanvas(finalScene)
    love.graphics.setColor(1, 1, 1, 1)
      love.graphics.draw(background, 0, --[[math.sin(player.sound:tell('samples') / 100000) * 20]]0, 0, luna.settings.video.w/background:getWidth(), luna.settings.video.h/background:getHeight())
    love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setCanvas()
end

function Background:keypressed(key)
end
