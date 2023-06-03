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

function StartSequence:update()
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

  --love.graphics.draw(playerBg, 0, 0, 0, luna.settings.video.h/playerBgD.w, luna.settings.video.h/playerBgD.h)
  --love.graphics.draw(monitorCanvas)
  --love.graphics.draw(hSyncMapCanvas)

  --[[effect(function()
    love.graphics.draw(
      monitorCanvas,
      luna.settings.video.w/4,
      luna.settings.video.h/4,
      0,
      0.5, 0.5
    )
  end)]]
end

function StartSequence:keypressed(key)
  if key == "screenshot" then
    finalScene:newImageData():encode("png", "tela.png")
  end
end
