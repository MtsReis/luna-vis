
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
  local MusicPos = player.sound:tell('samples')
	local MusicSize	= player.soundData:getSampleCount()
  local	Size = 1024

	if MusicPos >= MusicSize - Size then
		vis.scale.y = 20
		player:next()
  end

  -- Atualiza spectrum
	local List = {}
	for i= MusicPos, MusicPos + (Size-1) do
		if i + Size > MusicSize then i = MusicSize-Size end
		if player.soundData:getChannelCount()==1 then
			List[#List+1] = new(player.soundData:getSample(i), 0)
    else
			List[#List+1] = new(player.soundData:getSample(i*2), 0)
    end
  end
	vis.spectrum = fft( List, false )
  
  vis:pickColour(dt)
end

function Visualizer:draw()
  vis:drawGrid(player.np)
  
  vis:spectro_show()
end

function Visualizer:keypressed(key)
  if (key == "nextVis") then vis.line = not vis.line end
  if (key == "nextTrack") then player:next() end
  if (key == "prevTrack") then player:prev() end
end
