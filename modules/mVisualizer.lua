local gr = love.graphics
local Visualizer = class()

local Size = 612
local AMPLIFY = 2

-- Default settings
Visualizer.colours = {
  grid = {55, 155, 155, 256},
  spectrum = {0, 1, 0, 256},
  target = 1
}
Visualizer.spectrum = nil
Visualizer.line = true
Visualizer.fr = 8

Visualizer.screen = luna.settings.video
Visualizer.scale = { x = math.ceil(6*Visualizer.screen.w/Size), y = 900 }
Visualizer.win = { x=0, y=0, w=Visualizer.screen.w, h=Visualizer.screen.h }

function Visualizer:pickColour(dt)
  local rgb = self.colours.spectrum
  local target = self.colours.target
  local nextTarget = true
  local rate = 0.1
  
  for k = 3, 1, -1 do
    local key = math.pow(2, k-1)
    local lastTarget = target

    target = target - key

    if (target >= 0) then -- Cor permitida
      if (rgb[k] < 1) then
        rgb[k] = rgb[k] + dt * rate
        nextTarget = false
      end
    else -- Cor não inclusa
      if (rgb[k] > 0) then
        rgb[k] = rgb[k] - dt * rate
        nextTarget = false
      end
    end
    
    target = target < 0 and lastTarget or target -- Reseta target inicial se esta subtr remove td
  end
  
  self.colours.spectrum = rgb

  if (nextTarget) then
    self.colours.target = self.colours.target < 7 and self.colours.target + 1 or 1
  end
  
  luna.colours = rgb
  luna.colourTarget = self.colours.target
end

function Visualizer:spectro_show()
  gr.setColor(unpack(self.colours.spectrum))
	for i = 1, #self.spectrum/self.fr do
		local freq  = self.spectrum[i]:abs()
		local freq2 = self.spectrum[i+1]:abs()

		if self.scale.y*freq > self.win.h/2 then self.scale.y = (self.win.h/2)/freq end
		if self.line then
			--gr.rectangle('fill',
      --  self.win.w*math.log(i)/6+self.win.x,
      --  self.screen.h - AMPLIFY * freq*math.log(i) - self.win.y,
      --  2,
      --  AMPLIFY * freq*math.log(i)
      --)
			self.fr=2
			gr.line(
        self.win.w*math.log(i)/6+self.win.x,
        self.screen.h - AMPLIFY * freq*math.log(i) - self.win.y,
        self.win.w*math.log(i+1)/6+self.win.x,
        self.screen.h - AMPLIFY * freq2*math.log(i+1) - self.win.y
      )
    else
			self.fr=8
			gr.ellipse( 'line', i* self.scale.x+self.win.x, self.screen.h/2,  self.scale.x/6, -self.scale.y*freq )
			--gr.ellipse( 'line', 100*math.log(i)+win.x, screen.h/2,  2, -scale.y*freq )
    end
  end
end

return Visualizer
