class.StartSequence()

function StartSequence:load()
  --[[ Monitor canvas ]]
  monitorCanvas = love.graphics.newCanvas(luna.settings.monitorRes.w, luna.settings.monitorRes.h)
  hSyncMapCanvas = love.graphics.newCanvas(luna.settings.monitorRes.w, luna.settings.monitorRes.h)

  --[[ Player bg ]]
  playerBg = love.graphics.newImage("assets/images/player.png")
  playerBgD = { w = playerBg:getWidth(), h = playerBg:getHeight() }

  playerFg = love.graphics.newImage("assets/images/playerFg.png")

  relativeCenter = {
    x = (luna.settings.video.w - luna.settings.video.h/2)/2,
    y = luna.settings.video.h/4
  }

  --[[ Custom Shader ]]
  local hSync = [[
    uniform Image hSyncMap;

    vec4 effect(vec4 colour, Image image, vec2 uvs, vec2 screen_coords) {
      vec4 hSyncMapPixel = Texel(hSyncMap, uvs);

      if (hSyncMapPixel.r == 1) {
        return Texel(image, uvs);
      }

      if (hSyncMapPixel.b == 1) {
        return vec4(0, 0, 0, 1);
      }

      vec2 offset = vec2(hSyncMapPixel.g, 0);
      vec4 pixel = Texel(image, uvs - offset);

      return pixel;
    }
  ]]

  hSyncShader = love.graphics.newShader(hSync)
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
  love.graphics.setBackgroundColor( .1, .1, .1, 1 )

  -- Envia para shader e o aplica
  love.graphics.setShader(hSyncShader)
    hSyncShader:send("hSyncMap", hSyncMapCanvas)

    --[[ Player Background ]]
    love.graphics.draw(playerBg,
      relativeCenter.x,
      relativeCenter.y,
      0,
      luna.settings.video.h/playerBgD.w/2,
      luna.settings.video.h/playerBgD.h/2)

    --[[ Monitor Visualizer ]]
    love.graphics.draw(monitorCanvas,
      relativeCenter.x,
      relativeCenter.y,
      0,
      luna.settings.video.h/luna.settings.monitorRes.w/2,
      luna.settings.video.h/luna.settings.monitorRes.h/2)

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
end
