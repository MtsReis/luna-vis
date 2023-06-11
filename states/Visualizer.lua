local new = complex.new
class.Visualizer()

function Visualizer:load()
  player = require("modules/mMPlayer")
  vis = require("modules/mVisualizer")
end

function Visualizer:close()
end

function Visualizer:enable()
  player:playMusic()
end

function Visualizer:disable()
end

function Visualizer:update(dt)
  -- Identifica fim de track
  --local MusicPos = player.sound:tell('samples')
  local MusicPos = samplePosition * sampleSize

	musicSize	= 0
  if not pcall(function () musicSize = player.soundData:getSampleCount() end) then
    love.event.quit()
  end

  --[[if (time <= 1) then
    print("[Frame: "..currFrame.."] [samplePos: "..samplePosition.."] [Time: "..time.."]")
    print("[SamplePos: "..MusicPos / Size.."] [MTime: " .. player.sound:tell('seconds') .. "]")
  end]]

	if MusicPos >= musicSize - sampleSize then
		vis.scale.y = 20
		player:next()
  end

  -- Atualiza spectrum
	local List = {}
	for i= MusicPos, MusicPos + (sampleSize-1) do
		if i + sampleSize > musicSize then i = musicSize-sampleSize end
		if player.soundData:getChannelCount()==1 then
			List[#List+1] = new(player.soundData:getSample(i), 0)
    else
			List[#List+1] = new(player.soundData:getSample(i*2), 0)
    end
  end
	vis.spectrum = fft( List, false )
  
  vis:pickColour(dt)

  vis:updateVertices()
end

function Visualizer:draw()
  local polyCoords = {-1, 0}
  -- Desenha shader map para hSync
  love.graphics.setCanvas(hSyncMapCanvas)
  love.graphics.clear(1, 0, 0, 1)

  for i = 1, #vis.vertices do
    if vis.line then

      table.insert(polyCoords, vis.vertices[i].x - 1)
      table.insert(polyCoords, vis.vertices[i].y)

      love.graphics.setColor(0, vis.vertices[i].x/luna.settings.monitorRes.w, 0, 1)
      love.graphics.line(
        vis.vertices[i].x + 1,
        vis.vertices[i].y,
        luna.settings.monitorRes.w - 1,
        vis.vertices[i].y
      )
    end
  end

  table.insert(polyCoords, -1)
  table.insert(polyCoords, vis.vertices[#vis.vertices].y + 1)

  love.graphics.setColor(0, 0, 1, 1)
  local triangles = love.math.triangulate(polyCoords)

  for i, triangle in ipairs(triangles) do
    love.graphics.polygon("fill", triangle)
  end

  --[[ Limpa canvas antes de ir para próximo state ]]
  love.graphics.setCanvas(monitorCanvas)
    love.graphics.clear(0, 0, 0, 0)
  love.graphics.setCanvas()
end

function Visualizer:keypressed(key)
  if (key == "nextVis") then vis.line = not vis.line end
  if (key == "nextTrack") then player:next() end
  if (key == "prevTrack") then player:prev() end
end
