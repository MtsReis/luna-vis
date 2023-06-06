class.Background()

function Background:load()
  bgCanvas = love.graphics.newCanvas(luna.settings.video.w, luna.settings.video.h)
  monitorShadow = love.graphics.newCanvas(luna.settings.video.w, luna.settings.video.h)
  recCanvas = love.graphics.newCanvas(luna.settings.video.w, luna.settings.video.h)

  --[[ Background ]]
  background = love.graphics.newImage("assets/images/bg.png")

  --[[ monitorShadow ]]
  monitorShadowImg = love.graphics.newImage("assets/images/monitorShadow.png")

  local seta = love.graphics.newImage("assets/images/arrow.png")
  seta:setFilter("linear", "linear")

  bgPs = love.graphics.newParticleSystem(seta, 336)
  bgPs:setColors(
    .46, 0, 1, 0,
    .07, .07, 1, 1,
    .40, 0, 1, .5,
    .45, 0, 1, 0,
    .0, .40, 1, .5,
    .0, .40, 1, 0
  )
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
  love.graphics.setCanvas(monitorShadow)
    love.graphics.setColor(0, 0, 0, .5)
      love.graphics.clear(0, 0, 0, 0)
      love.graphics.draw(monitorShadowImg)
  love.graphics.setCanvas()
end

function Background:disable()
end

function Background:update(dt)
  if (stage == 2) then
    bgPs:update(dt)
  end
end

function Background:draw()
  --[[ STAGE 2 ]]
  -- Desenha partículas em um fundo sem clear
  if (stage == 2) then
    love.graphics.setCanvas(bgCanvas)
      love.graphics.setBlendMode("alpha")
        love.graphics.draw(bgPs, luna.settings.video.w/2 - fgOffset.x, luna.settings.video.h/2, luna.colours[1])

    -- Já desenha canvas no finalScene
    love.graphics.setCanvas(frame)
      love.graphics.setColor((1 - luna.colours[1]) * stageIntensity, (1 - luna.colours[2]) * stageIntensity, (1 - luna.colours[3]) * stageIntensity, 1) -- Cor invertida
        love.graphics.draw(bgCanvas)
      love.graphics.setColor(stageIntensity, stageIntensity, stageIntensity, stageIntensity)
    love.graphics.setCanvas()
  end

  love.graphics.setCanvas(finalScene)
  -- Desenha imagem de fundo sobre as partículas
    if (stage == 1 or stage > 2) then --[[ STAGE 1 ]]
        love.graphics.setColor(1, 1, 1, stageIntensity)
          love.graphics.draw(background, 0, fgOffset.y, 0, luna.settings.video.w/background:getWidth(), luna.settings.video.h/background:getHeight())
        love.graphics.setColor(1, 1, 1, 1)
    else --[[ STAGE 2 & STAGE 3 ]]
      love.graphics.clear(0, 0, 0, 0)
        love.graphics.draw(monitorShadow, 0, fgOffset.y, 0, luna.settings.video.w/background:getWidth(), luna.settings.video.h/background:getHeight())
      love.graphics.setColor(1, 1, 1, 1)
    end
  love.graphics.setCanvas()
end

function Background:keypressed(key)
end
