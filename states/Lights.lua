class.Lights()

function Lights:load()
  -- Maps
  lightsMapImage = love.graphics.newImage("assets/images/lights.png")
  powerOnImage = love.graphics.newImage("assets/images/powerOn.png")
  clock = {}

  for i = 1, 5 do
    table.insert(clock, love.graphics.newImage("assets/images/clock/" .. i .. ".png"));
  end

  --[[ Custom Shaders ]]
  lightsShader = love.graphics.newShader(require("shaders/lights"))

  --[[ Frame canvas ]]
  frame = love.graphics.newCanvas(luna.settings.video.w, luna.settings.video.h)

  flick = 0;
end

function Lights:close()
end

function Lights:enable()
end

function Lights:disable()
end

function Lights:update(dt)
  flick = 0

  for i = 1, 4 do
    if (math.random(10 * i) == 3) then
      flick = flick + 0.01 * i
    end
  end
end

function Lights:draw()
  local lightIntensity = stage == 3 and 1 - stageIntensity or stageIntensity

  -- [[ Desenha cena final ]]
  love.graphics.setCanvas(finalScene)
    if (stage == 4) then
      love.graphics.setColor(lightIntensity, lightIntensity, lightIntensity, 1)
    end
      love.graphics.draw(finalMonitorCanvas,
            relativeCenter.x,
            relativeCenter.y,
            0, .48, .48)
    love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setCanvas(frame)

    -- Aplica lightMap
    if (stage == 1 or stage > 2) then
    love.graphics.setShader(lightsShader)
      lightsShader:send("lightMap", lightsMapImage)
      lightsShader:send("intensity", ( ((1.5 + math.cos((time + 5000) * .2))/2) - flick) * lightIntensity)
    end

    love.graphics.draw(finalScene, fgOffset.x, fgOffset.y)

    --[[ STAGE 3: GHOSTS ]]
    if (stage == 3) then

    end
    love.graphics.setShader()

    love.graphics.setColor(1, 1, 1, (1 - stage*.1 + math.random(10) * stage * .01) * lightIntensity)
      if (stage == 1 or stage > 2) then
        love.graphics.draw(clock[minute], fgOffset.x, fgOffset.y)
      end

      if (stage < 4) then -- Transição de fim do stage 4 afeta esta luz
        love.graphics.setColor(1, 1, 1, (1 - stage*0.1 + math.random(10) * stage * 0.01))
      else
        love.graphics.setColor(1, 1, 1, (1 - stage*0.1 + math.random(10) * stage * 0.01) * lightIntensity)
      end
      love.graphics.draw(powerOnImage, fgOffset.x, fgOffset.y)

      love.graphics.print(minute, 800, 300 + 200)
      love.graphics.print(time, 800, 325 + 200)

      love.graphics.print(stage, 800, 350 + 200)
      love.graphics.print(fgOffset.y, 800, 375 + 200)

      love.graphics.print(stageIntensity, 800, 400 + 200)

      love.graphics.setColor(1, 1, 1, beat - 1)
        love.graphics.print(beat, 800, 425 + 200)
      love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setColor(1, 1, 1, 1)

  love.graphics.setCanvas()
    love.graphics.draw(frame, -love.mouse.getX(), -love.mouse.getY())
    --love.graphics.draw(frame, -550, -150)
end

function Lights:keypressed(key)
  if key == "screenshot" then
    frame:newImageData():encode("png", "frame.png")
    monitorCanvas:newImageData():encode("png", "monitorCanvas.png")
    hSyncMapCanvas:newImageData():encode("png", "hSyncMapCanvas.png")
    posthSyncCanvas:newImageData():encode("png", "posthSyncCanvas.png")
    finalMonitorCanvas:newImageData():encode("png", "finalMonitorCanvas.png")
    finalScene:newImageData():encode("png", "finalScene.png")
  end
end
