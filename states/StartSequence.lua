class.StartSequence()

function StartSequence:load()
  --[[ Monitor canvas ]]
  monitorCanvas = love.graphics.newCanvas(luna.settings.monitorRes.w, luna.settings.monitorRes.h)
  hSyncMapCanvas = love.graphics.newCanvas(luna.settings.monitorRes.w, luna.settings.monitorRes.h)
  posthSyncCanvas = love.graphics.newCanvas(luna.settings.monitorRes.w, luna.settings.monitorRes.h)
  finalMonitorCanvas = love.graphics.newCanvas(luna.settings.monitorRes.w, luna.settings.monitorRes.h)

  --[[ Player bg ]]
  playerBg = love.graphics.newImage("assets/images/player.png")
  playerBgD = { w = playerBg:getWidth(), h = playerBg:getHeight() }
  playerFg = love.graphics.newImage("assets/images/playerFg.png")

  relativeCenter = {
    x = ((luna.settings.video.w - luna.settings.monitorRes.w/2)/2) * 1.02,
    y = ((luna.settings.video.h - luna.settings.monitorRes.h/2)/2 - 1) * 1.03
  }

  fgOffset = {x = 0, y = 0}

  --[[ Custom Shaders ]]
  hSyncShader = love.graphics.newShader(require("shaders/hsync"))
  crtShader = love.graphics.newShader(require("shaders/crt"))
end

function StartSequence:close()
end

function StartSequence:enable()
  -- Ativa sequências necessárias
  enableState("Visualizer")
	enableState("Particles")
end

function StartSequence:disable()
end

function StartSequence:update(dt)
  if (stage > 1 and stageIII.step < 3) then
    fgOffset.y = math.sin(time / 5) * 20
  elseif (fgOffset.y > 0) then
    fgOffset.y = fgOffset.y - dt*5 > 0 and fgOffset.y - dt*5 or 0
  elseif (fgOffset.y < 0) then
    fgOffset.y = fgOffset.y + dt*5 < 0 and fgOffset.y + dt*5 or 0
  end
end

function StartSequence:draw()
  --[[ Desenha playerBG e visualizer, aplica hSync e desenha no posthSyncCanvas ]]
  love.graphics.setCanvas(posthSyncCanvas)
    love.graphics.setShader(hSyncShader)
      hSyncShader:send("hSyncMap", hSyncMapCanvas)
      --[[ Monitor Visualizer ]]
      love.graphics.draw(monitorCanvas)
    love.graphics.setShader()

  --[[ Desenha resultado na tela com shader de CRT ]]
  love.graphics.setCanvas(finalMonitorCanvas)
    love.graphics.setShader(crtShader)
      love.graphics.draw(posthSyncCanvas)
    love.graphics.setShader()
end

function StartSequence:keypressed(key)
  if key == "screenshot" then
    finalScene:newImageData():encode("png", "tela.png")
  end
end
