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
  grayShader = love.graphics.newShader(require("shaders/grayscale"))

  --[[ Frame canvas ]]
  frame = love.graphics.newCanvas(luna.settings.video.w, luna.settings.video.h)
  postShader = love.graphics.newCanvas(luna.settings.video.w, luna.settings.video.h)

  flick = 0;
  
  ghost = {
    {x = relativeCenter.x, y = relativeCenter.y, o = 0, s = 1},
    {x = relativeCenter.x, y = relativeCenter.y, o = 0, s = 1},
    {x = relativeCenter.x, y = relativeCenter.y, o = 0, s = 1}
  }
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
  
  if (stage == 3) then
    if (stageIII.step == 1) then -- RedGhost sai
      if (stageIII.timer > 2.5 and stageIII.timer < 5.5) then -- 3 segundos de transição
        local moveFactor = math.sin((stageIII.timer - 2.5)/2)
        local opacity = math.sin((stageIII.timer - 2.5))
        ghost[1].x = ghost[1].x - moveFactor * 5
        ghost[1].o = opacity
        stageIII.saturation = opacity
        
        if (ghost[1].s > .5) then
          ghost[1].s = ghost[1].s - opacity
        end
      end
      
      if (stageIII.timer < 2.5) then -- Garante valores finais
        ghost[1].o = 0
        ghost[1].s = 0.5
      end
    end
    
    if (stageIII.step == 2) then -- Blue and green saem
      if (stageIII.timer > .5) then -- GREEN 1 segundo
        local moveFactor = math.sin((stageIII.timer - .5)*math.pi/2)
        local opacity = math.sin((stageIII.timer - .5)*math.pi)
        ghost[2].x = ghost[2].x + moveFactor * 5
        ghost[2].y = ghost[2].y - moveFactor
        ghost[2].o = opacity
        
        if (ghost[2].s > .5) then
          ghost[2].s = ghost[2].s - opacity
        end
      end
      
      if (stageIII.timer < 1) then -- GREEN 1 segundo
        local moveFactor = math.sin(stageIII.timer*math.pi/2)
        local opacity = math.sin(stageIII.timer*math.pi)
        ghost[3].x = ghost[3].x - moveFactor * 5
        ghost[3].y = ghost[3].y - moveFactor
        ghost[3].o = opacity
        
        if (ghost[3].s > .5) then
          ghost[3].s = ghost[3].s - opacity
        end
      end
    end
    
    if (stageIII.step == 3) then
      ghost[2].o = 0
      ghost[3].o = 0
      ghost[2].s = 0.5
      ghost[3].s = 0.5
    end
  end
end

function Lights:draw()
  local lightIntensity = stageIntensity

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
  love.graphics.setCanvas(postShader)

    -- Aplica lightMap
    if (stage == 1 or stage > 3) then
    love.graphics.setShader(lightsShader)
      lightsShader:send("lightMap", lightsMapImage)
      lightsShader:send("intensity", ( ((1.5 + math.cos((time + 5000) * .2))/2) - flick) * lightIntensity)
    elseif (stage == 3) then
      love.graphics.setShader(grayShader)
      grayShader:send("intensity", stageIII.saturation)
      love.graphics.setColor(ghost[1].s, ghost[2].s, ghost[3].s, 1)
    end

      love.graphics.draw(finalScene, fgOffset.x, fgOffset.y)

      --[[ STAGE 3: GHOSTS ]]
      if (stage == 3) then
        local currShader = love.graphics.getShader()
        love.graphics.setShader()

        -- Desenha monitores coloridos
        local r, g, b, a = love.graphics.getColor()
        for i = 1, 3 do
          local rgb = {0, 0, 0, 1}
          rgb[i] = 1
          rgb[4] = ghost[i].o
          love.graphics.setColor(unpack(rgb))
          love.graphics.draw(
            finalMonitorCanvas,
            ghost[i].x + fgOffset.x,
            ghost[i].y + fgOffset.y,
          0, .48, .48)
        end
        
        love.graphics.setShader(currShader)
        love.graphics.setColor(r, g, b, a)
      end
      
      
      love.graphics.setColor(1, 1, 1, (1 - stage*.1 + math.random(10) * stage * .01) * lightIntensity)
        if (stage == 1 or stage == 4) then
          love.graphics.setShader()
          love.graphics.draw(clock[minute], fgOffset.x, fgOffset.y)
        end

        if (stage < 3) then -- Transição de fim do stage 4 afeta esta luz
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
        
        love.graphics.print("Step: "..stageIII.step, 800, 450 + 200)
        love.graphics.print("Timer: "..stageIII.timer, 800, 475 + 200)
      love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setShader()
  love.graphics.setCanvas(frame)
    love.graphics.draw(postShader)
    
  love.graphics.setCanvas()

  love.graphics.draw(frame, -love.mouse.getX(), -love.mouse.getY())
end

function Lights:keypressed(key)
  if key == "screenshot" then
    frame:newImageData():encode("png", "frame.png")
    monitorCanvas:newImageData():encode("png", "monitorCanvas.png")
    hSyncMapCanvas:newImageData():encode("png", "hSyncMapCanvas.png")
    posthSyncCanvas:newImageData():encode("png", "posthSyncCanvas.png")
    finalMonitorCanvas:newImageData():encode("png", "finalMonitorCanvas.png")
    finalScene:newImageData():encode("png", "finalScene.png")
    postShader:newImageData():encode("png", "postShader.png")
    bgCanvas:newImageData():encode("png", "bgCanvas.png")
  end
end
