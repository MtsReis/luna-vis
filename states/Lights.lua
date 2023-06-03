class.Lights()

function Lights:load()
  -- Maps
  lightsMapImage = love.graphics.newImage("assets/images/lights.png")
  
  --[[ Custom Shaders ]]
  lightsShader = love.graphics.newShader(require("shaders/lights"))
  
  --[[ Frame canvas ]]
  frame = love.graphics.newCanvas(luna.settings.video.w, luna.settings.video.h)
end

function Lights:close()
end

function Lights:enable()
end

function Lights:disable()
end

function Lights:update()
end

function Lights:draw()
  
  -- [[ Desenha cena final ]]
  love.graphics.setCanvas(finalScene)
      love.graphics.draw(finalMonitorCanvas,
            relativeCenter.x,
            relativeCenter.y --[[+ math.sin(player.sound:tell('samples') / 100000) * 20]],
            0, .48, .48)
  love.graphics.setCanvas(frame)
  
    love.graphics.setShader(lightsShader)
      lightsShader:send("lightMap", lightsMapImage)
      lightsShader:send("intensity", (1.5 + math.sin(time * .2))/2)
      love.graphics.draw(finalScene)
    love.graphics.setShader()
  love.graphics.setCanvas()
  
  love.graphics.draw(frame, -300, -300)
end

function Lights:keypressed(key)
  if key == "screenshot" then
    frame:newImageData():encode("png", "tela.png")
  end
end
