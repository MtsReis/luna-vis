class.Background()

function Background:load()
  bgCanvas = love.graphics.newCanvas(luna.settings.video.w, luna.settings.video.h)
  monitorShadow = love.graphics.newCanvas(luna.settings.video.w, luna.settings.video.h)
  recCanvas = love.graphics.newCanvas(luna.settings.video.w, luna.settings.video.h)

  --[[ Background ]]
  background = love.graphics.newImage("assets/images/bg.png")

  --[[ monitorShadow ]]
  monitorShadowImg = love.graphics.newImage("assets/images/monitorShadow.png")

  bgPs = require("particles/seta")
  fPs = require("particles/flies")
  
  fpsScale = 0
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
  
  if (stage == 3) then
    fpsScale = fpsScale + dt
    fPs:setEmissionArea("uniform", 400, 400 + fpsScale * 100, 0, false)
    fPs:setLinearAcceleration(15 - fpsScale * 2, -12, 250 - fpsScale * 100, 24)
    fPs:update(dt)
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
    love.graphics.setCanvas(postShader)
      love.graphics.setColor((1 - luna.colours[1]) * stageIntensity, (1 - luna.colours[2]) * stageIntensity, (1 - luna.colours[3]) * stageIntensity, 1) -- Cor invertida
        love.graphics.draw(bgCanvas)
      love.graphics.setColor(stageIntensity, stageIntensity, stageIntensity, stageIntensity)
    love.graphics.setCanvas()
  end
  
  if (stage == 3) then
    love.graphics.setCanvas(frame)
      love.graphics.clear()
    
    love.graphics.setCanvas(bgCanvas)
      love.graphics.setBlendMode("alpha")
      love.graphics.clear()
      local fPsX = fpsScale*100 < luna.settings.video.w and fpsScale*150 or luna.settings.video.w
      
      if (stageIII.step >= 4) then
        if (stageIII.timer > 10) then -- 2 segundos de transição
          local tranTimer = (stageIII.timer - 10)/2
          love.graphics.setColor(tranTimer, tranTimer, tranTimer, tranTimer)
          --love.graphics.draw(fPs, fPsX, luna.settings.video.h/2) -- Flies
        end
      else
        love.graphics.draw(fPs, fPsX, luna.settings.video.h/2) -- Flies
      end

    -- Já desenha canvas no finalScene
    love.graphics.setCanvas(postShader)
      love.graphics.clear()
      love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(bgCanvas)
    love.graphics.setCanvas()
  end

  love.graphics.setCanvas(finalScene)
  -- Desenha imagem de fundo sobre as partículas
    if (stage == 1 or stage == 4) then --[[ STAGE 1 & 4 ]]
        love.graphics.setColor(1, 1, 1, stageIntensity)
          love.graphics.draw(background, 0, fgOffset.y, 0, luna.settings.video.w/background:getWidth(), luna.settings.video.h/background:getHeight())
        love.graphics.setColor(1, 1, 1, 1)
    elseif (stage == 2) then --[[ STAGE 2]]
      love.graphics.clear(0, 0, 0, 0)
        love.graphics.draw(monitorShadow, 0, fgOffset.y, 0, luna.settings.video.w/background:getWidth(), luna.settings.video.h/background:getHeight())
      love.graphics.setColor(1, 1, 1, 1)
    else  --[[ STAGE 3]]
      love.graphics.clear(0, 0, 0, 0)

      love.graphics.setColor(1, 1, 1, 1 - stageIntensity) -- Fade in
        love.graphics.draw(background,
          0,
          fgOffset.y,
          0,
          luna.settings.video.w/background:getWidth(),
          luna.settings.video.h/background:getHeight()
        )

      love.graphics.setColor(1, 1, 1, stageIntensity) -- Fade out
        love.graphics.draw(monitorShadow,
          0,
          fgOffset.y,
          0,
          luna.settings.video.w/background:getWidth(),
          luna.settings.video.h/background:getHeight()
        )
      love.graphics.setColor(1, 1, 1, 1)
    end
  love.graphics.setCanvas()
end

function Background:keypressed(key)
end
