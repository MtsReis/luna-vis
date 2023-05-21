class.StartSequence()

function StartSequence:load()
  --[[Monitor canvas]]
  monitorCanvas = love.graphics.newCanvas(luna.settings.video.w, luna.settings.video.h)

  local monitorRes = {
    w = luna.settings.video.w/2, 
    h = luna.settings.video.h/2
  }
  --[[ Shader effects]]
  effect = moonshine(luna.settings.video.w, luna.settings.video.h, moonshine.effects.vignette)
  effect.parameters = {}

  --[[ Custom Shader ]]
  local hSync = [[
    extern vec2 pixelSize;

    vec4 effect(vec4 colour, Image image, vec2 uvs, vec2 screen_coords) {
      vec2 offset = vec2(pixelSize.x, 0);
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
  --[[effect(function()
    love.graphics.draw(
      monitorCanvas,
      luna.settings.video.w/4,
      luna.settings.video.h/4,
      0,
      0.5, 0.5
    )
  end)]]

  love.graphics.setShader(hSyncShader)
  hSyncShader:send("pixelSize", {1/luna.settings.video.w, 1/luna.settings.video.h})
  love.graphics.draw(monitorCanvas)
  love.graphics.setShader()
end

function StartSequence:keypressed(key)
end
